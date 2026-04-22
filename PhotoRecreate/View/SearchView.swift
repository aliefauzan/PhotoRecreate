//
//  SearchView.swift
//  PhotoRecreate
//
//  Created by Antonio Palomba on 15/04/26.
//

import PhotosUI
import SwiftUI

struct SearchView: View {
    private enum ExerciseTypeOption: String, CaseIterable, Identifiable {
        case plank
        case squat
        case lunge
        case bicepCurl = "bicep_curl"

        var id: String { rawValue }

        var title: String {
            switch self {
            case .plank:
                return "Plank"
            case .squat:
                return "Squat"
            case .lunge:
                return "Lunge"
            case .bicepCurl:
                return "Bicep Curl"
            }
        }
    }

    @State private var selectedExercise: ExerciseTypeOption = .plank
    @State private var selectedVideoItem: PhotosPickerItem?
    @State private var selectedVideoURL: URL?
    @State private var selectedVideoName = "No video selected"
    @State private var isAnalyzing = false
    @State private var analysisResult: AnalysisResult?
    @State private var analysisError: String?
    @State private var showResult = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Analyze Workout")
                            .font(.largeTitle.bold())
                        Text("Pick a real workout video, send it to the exercise model, and review the detected mistakes with snapshots.")
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Exercise Type")
                            .font(.headline)

                        Picker("Exercise", selection: $selectedExercise) {
                            ForEach(ExerciseTypeOption.allCases) { option in
                                Text(option.title).tag(option)
                            }
                        }
                        .pickerStyle(.segmented)
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Workout Video")
                            .font(.headline)

                        PhotosPicker(
                            selection: $selectedVideoItem,
                            matching: .videos,
                            photoLibrary: .shared()
                        ) {
                            HStack {
                                Image(systemName: "video.badge.plus")
                                Text("Choose Video")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(Color(.systemBackground))
                            )
                        }
                        .buttonStyle(.plain)

                        Text(selectedVideoName)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    if let analysisError {
                        Text(analysisError)
                            .font(.subheadline)
                            .foregroundStyle(.red)
                    }

                    Button {
                        Task {
                            await analyzeSelectedVideo()
                        }
                    } label: {
                        HStack {
                            if isAnalyzing {
                                ProgressView()
                                    .tint(.white)
                            }
                            Text(isAnalyzing ? "Analyzing..." : "Run Analysis")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .foregroundStyle(.white)
                    }
                    .disabled(isAnalyzing || selectedVideoURL == nil)
                }
                .padding()
            }
            .navigationDestination(isPresented: $showResult) {
                DetailsWorkoutView()
            }
            .onChange(of: selectedVideoItem) { _, newItem in
                Task {
                    await loadSelectedVideo(from: newItem)
                }
            }
        }
    }

    @MainActor
    private func loadSelectedVideo(from item: PhotosPickerItem?) async {
        guard let item else { return }

        do {
            if let existingURL = selectedVideoURL {
                try? FileManager.default.removeItem(at: existingURL)
            }

            guard let movieData = try await item.loadTransferable(type: Data.self) else {
                analysisError = "Could not read the selected video."
                return
            }

            let tempURL = FileManager.default.temporaryDirectory
                .appendingPathComponent("analysis-\(UUID().uuidString).mp4")
            try movieData.write(to: tempURL, options: .atomic)

            selectedVideoURL = tempURL
            selectedVideoName = tempURL.lastPathComponent
            analysisError = nil
        } catch {
            analysisError = "Failed to prepare the selected video."
        }
    }

    @MainActor
    private func analyzeSelectedVideo() async {
        guard let selectedVideoURL else {
            analysisError = "Choose a video first."
            return
        }

        isAnalyzing = true
        analysisError = nil

        do {
            let result = try await ExerciseCorrectionService.shared.analyzeVideo(
                videoURL: selectedVideoURL,
                exerciseType: selectedExercise.rawValue
            )
            analysisResult = result
            showResult = true
        } catch {
            analysisError = "Analysis failed. Please try another clip or check the server connection."
        }

        isAnalyzing = false
    }
}

#Preview {
    SearchView()
}
