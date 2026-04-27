import Foundation
import SwiftUI
import AVKit

// MARK: - What we save to disk (simple Codable struct)
struct SavedVideo: Codable {
    let videoFileName: String       // file name in Documents folder
    let exerciseName: String        // e.g. "Squat"
    let exerciseIconURL: String     // Unsplash URL for "How to" tab
    let exerciseExplanation: String
    let date: Date
    let llmFeedback: String?        // AI coaching text from backend
    let analysisType: String?       // e.g. "squat" — from backend response
}

// MARK: - WorkoutStore (saves & loads workout videos)
@Observable
class WorkoutStore {
    var workoutItems: [WorkoutItem] = []

    private static var fileURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("saved_workouts.json")
    }

    init() {
        loadFromDisk()
    }

    // MARK: - Save a new video to disk
    func saveVideo(_ video: WorkoutItemVideo) {
        let saved = SavedVideo(
            videoFileName: video.video.lastPathComponent,
            exerciseName: video.exerciseType.name,
            exerciseIconURL: video.exerciseType.icon.absoluteString,
            exerciseExplanation: video.exerciseType.explanation,
            date: video.date,
            llmFeedback: video.analysisResult?.llmFeedback,
            analysisType: video.analysisResult?.type
        )

        var all = loadSavedVideos()
        all.append(saved)
        writeToDisk(all)
    }

    // MARK: - Load saved videos from disk on app launch
    func loadFromDisk() {
        let savedVideos = loadSavedVideos()
        let docsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

        var items: [WorkoutItem] = []

        for saved in savedVideos {
            let videoURL = docsDir.appendingPathComponent(saved.videoFileName)

            // Skip if the video file was deleted
            guard FileManager.default.fileExists(atPath: videoURL.path) else { continue }

            let exerciseType = ExerciseType(
                name: saved.exerciseName,
                icon: URL(string: saved.exerciseIconURL) ?? URL(string: "https://example.com")!,
                explanation: saved.exerciseExplanation
            )

            // Rebuild a minimal AnalysisResult if we have feedback
            var analysisResult: AnalysisResult?
            if let feedback = saved.llmFeedback, let type = saved.analysisType {
                analysisResult = AnalysisResult(
                    type: type,
                    feedback: feedback
                )
            }

            // Generate thumbnail from the actual video
            let thumb = generateThumbnail(from: videoURL)

            let video = WorkoutItemVideo(
                video: videoURL,
                thumbnail: .workoutVideo1,
                date: saved.date,
                exerciseType: exerciseType,
                analysisResult: analysisResult,
                thumbnailImage: thumb
            )

            items.addVideo(video)
        }

        // Always have a "Today" entry so the user can tap "+" to add videos
        let today = Date()
        if !items.contains(where: { Calendar.current.isDate($0.date, inSameDayAs: today) }) {
            items.append(WorkoutItem(thumbnail: .workoutVideo1, date: today))
        }

        workoutItems = items
    }

    // MARK: - Private helpers

    private func loadSavedVideos() -> [SavedVideo] {
        guard let data = try? Data(contentsOf: Self.fileURL) else { return [] }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return (try? decoder.decode([SavedVideo].self, from: data)) ?? []
    }

    private func writeToDisk(_ videos: [SavedVideo]) {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        guard let data = try? encoder.encode(videos) else { return }
        try? data.write(to: Self.fileURL, options: .atomic)
    }

    private func generateThumbnail(from videoURL: URL) -> UIImage? {
        let asset = AVAsset(url: videoURL)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        let time = CMTime(seconds: 0.5, preferredTimescale: 600)
        guard let cgImage = try? generator.copyCGImage(at: time, actualTime: nil) else { return nil }
        return UIImage(cgImage: cgImage)
    }
}
