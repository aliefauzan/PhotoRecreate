//
//  CollectionsAlief.swift
//  PhotoRecreate
//
//  Created by Andi Muhammad Alief Fauzan on 18/04/26.
//
import AVKit
import PhotosUI
import SwiftUI

struct DailyWorkoutView: View {
    @Binding var item: WorkoutItem
    var store: WorkoutStore
    @State private var showAddVideoSheet = false

    var groupedVideos: [String: [WorkoutItemVideo]] {
        Dictionary(grouping: item.videos, by: { $0.exerciseType.name })
    }

    var body: some View {
        ScrollView {
            ForEach(groupedVideos.keys.sorted(), id: \.self) { category in
                Segment(
                    title: category,
                    cardType: .noTitle,
                    workoutVideos: groupedVideos[category] ?? []
                )
            }
        }
        .navigationTitle(item.title)
        .toolbarTitleDisplayMode(.inlineLarge)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showAddVideoSheet = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showAddVideoSheet) {
            AddVideoSheet(workoutDate: item.date) { newVideo in
                item.videos.append(newVideo)
                store.saveVideo(newVideo) // persist to disk
            }
        }
    }
}

private enum ExerciseTag: String, CaseIterable, Identifiable {
    case squat
    case plank
    case lunge
    case bicepCurl = "bicep_curl"

    var id: String { rawValue }

    var title: String {
        switch self {
        case .squat: return "Squat"
        case .plank: return "Plank"
        case .lunge: return "Lunge"
        case .bicepCurl: return "Bicep Curl"
        }
    }

    var exerciseType: ExerciseType {
        switch self {
        case .squat:
            return ExerciseType(
                name: "Squat",
                icon: URL(string: "https://images.unsplash.com/photo-1574673130244-c707ca123514?auto=format&fit=crop&q=80&w=600")!,
                explanation: "Stand with feet shoulder-width apart. Lower your hips back and down, keeping your chest up and knees tracking over your toes. Push through your heels to return to standing."
            )
        case .plank:
            return ExerciseType(
                name: "Plank",
                icon: URL(string: "https://images.unsplash.com/photo-1566241142559-40e1dab266c6?auto=format&fit=crop&q=80&w=600")!,
                explanation: "Start in a push-up position with forearms on the ground. Keep your body in a straight line from head to heels. Engage your core and hold the position."
            )
        case .lunge:
            return ExerciseType(
                name: "Lunge",
                icon: URL(string: "https://images.unsplash.com/photo-1434682881908-b43d0467b798?auto=format&fit=crop&q=80&w=600")!,
                explanation: "Step forward with one leg and lower your hips until both knees are bent at about 90 degrees. Keep your front knee over your ankle and push back to standing."
            )
        case .bicepCurl:
            return ExerciseType(
                name: "Bicep Curl",
                icon: URL(string: "https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?auto=format&fit=crop&q=80&w=600")!,
                explanation: "Hold dumbbells at your sides with palms facing forward. Curl the weights up toward your shoulders, keeping your elbows pinned to your sides. Lower with control."
            )
        }
    }
}

private struct AddVideoSheet: View {
    let workoutDate: Date
    let onSave: (WorkoutItemVideo) -> Void

    @Environment(\.dismiss) private var dismiss

    @State private var selectedVideoItem: PhotosPickerItem?
    @State private var selectedVideoURL: URL?
    @State private var selectedExercise: ExerciseTag = .squat
    @State private var selectedVideoName = "No video selected"
    @State private var isAnalyzing = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
                PhotosPicker(
                    selection: $selectedVideoItem,
                    matching: .videos,
                    photoLibrary: .shared()
                ) {
                    videoPickerBox
                }
                .buttonStyle(.plain)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Exercise Type")
                        .font(.headline)

                    Picker("Exercise", selection: $selectedExercise) {
                        ForEach(ExerciseTag.allCases) { tag in
                            Text(tag.title).tag(tag)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                if let errorMessage {
                    Text(errorMessage)
                        .font(.subheadline)
                        .foregroundStyle(.red)
                }

                Spacer()

                Button {
                    analyzeAndSave()
                } label: {
                    HStack {
                        if isAnalyzing {
                            ProgressView()
                                .tint(.white)
                        }
                        Text(isAnalyzing ? "Analyzing..." : "Save & Analyze")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black.opacity(selectedVideoURL == nil || isAnalyzing ? 0.35 : 0.75))
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .disabled(selectedVideoURL == nil || isAnalyzing)
            }
            .padding()
            .navigationTitle("Add Video")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onChange(of: selectedVideoItem) { _, newItem in
                Task {
                    await loadVideo(from: newItem)
                }
            }
        }
    }

    private var videoPickerBox: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color(.systemGray5))
            .frame(height: 180)
            .overlay {
                VStack(spacing: 8) {
                    Image(systemName: "video.badge.plus")
                        .font(.title)

                    Text("Choose Video")
                        .font(.headline)

                    Text(selectedVideoName)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
    }

    @MainActor
    private func loadVideo(from item: PhotosPickerItem?) async {
        guard let item else { return }

        do {
            guard let videoData = try await item.loadTransferable(type: Data.self) else {
                errorMessage = "Could not read the selected video."
                return
            }

            selectedVideoURL = try copyVideoToAppFolder(videoData)
            selectedVideoName = selectedVideoURL?.lastPathComponent ?? "Video selected"
            errorMessage = nil
        } catch {
            errorMessage = "Failed to add video."
        }
    }

    @MainActor
    private func analyzeAndSave() {
        guard let selectedVideoURL else {
            errorMessage = "Choose a video first."
            return
        }

        isAnalyzing = true
        errorMessage = nil

        Task {
            do {
                // Generate thumbnail from the actual video
                let thumb = generateThumbnail(from: selectedVideoURL)

                // Upload video to backend and get AI analysis
                let result = try await ExerciseCorrectionService.shared.analyzeVideo(
                    videoURL: selectedVideoURL,
                    exerciseType: selectedExercise.rawValue
                )

                let newVideo = WorkoutItemVideo(
                    video: selectedVideoURL,
                    thumbnail: .workoutVideo1,
                    date: workoutDate,
                    exerciseType: selectedExercise.exerciseType,
                    analysisResult: result,
                    thumbnailImage: thumb
                )

                onSave(newVideo)
                dismiss()
            } catch {
                print("[Analysis] Failed with error: \(error)")
                errorMessage = "Analysis failed: \(error.localizedDescription)"
                isAnalyzing = false
            }
        }
    }

    /// Grabs a single frame from the video to use as a thumbnail
    private func generateThumbnail(from videoURL: URL) -> UIImage? {
        let asset = AVAsset(url: videoURL)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true

        let time = CMTime(seconds: 0.5, preferredTimescale: 600)
        do {
            let cgImage = try generator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: cgImage)
        } catch {
            print("[Thumbnail] Failed to generate: \(error)")
            return nil
        }
    }

    private func copyVideoToAppFolder(_ videoData: Data) throws -> URL {
        let folder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = folder.appendingPathComponent("workout-\(UUID().uuidString).mp4")

        try videoData.write(to: fileURL, options: .atomic)
        return fileURL
    }
}

#Preview {
    NavigationStack {
        DailyWorkoutView(item: .constant(WorkoutItem.sampleData[0]), store: WorkoutStore())
    }
}
