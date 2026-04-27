import Foundation
import SwiftUI

struct WorkoutItem: Identifiable {
    let id = UUID()
    let thumbnail: ImageResource
    let date: Date
    var videos: [WorkoutItemVideo] = []
    
    var title: String {
        "Workout at \(date.formattedWorkoutDate)"
    }
}

struct WorkoutItemVideo: Identifiable {
    let id = UUID()
    let video: URL
    let thumbnail: ImageResource
    let date: Date
    var exerciseType: ExerciseType
    var analysisResult: AnalysisResult?
    var thumbnailImage: UIImage?
}

struct ExerciseType {
    let name: String
    let icon: URL
    let explanation: String
}

extension Date {
    var formattedWorkoutDate: String {
        let calendar = Calendar.current
        
        if calendar.isDateInToday(self) {
            return "Today"
        } else if calendar.isDateInYesterday(self) {
            return "Yesterday"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM"
            return formatter.string(from: self)
        }
    }
}

extension ExerciseType {
    static let sample: [ExerciseType] = [
        ExerciseType(
            name: "Barbell Back Squat",
            icon: URL(string: "https://images.unsplash.com/photo-1574673130244-c707ca123514?auto=format&fit=crop&q=80&w=600")!,
            explanation: "Rest the bar on your upper traps. Sit back into your hips, keep your chest up, and descend until thighs are parallel to the floor. Drive upward through your mid-foot."
        ),
        
        ExerciseType(
            name: "Flat Bench Press",
            icon: URL(string: "https://images.unsplash.com/photo-1534438327276-14e5300c3a48?auto=format&fit=crop&q=80&w=600")!,
            explanation: "Lie flat on the bench. Lower the barbell to mid-chest while keeping your elbows at a 45-degree angle. Press the bar back up to full lockout."
        ),
        
        ExerciseType(
            name: "Conventional Deadlift",
            icon: URL(string: "https://images.unsplash.com/photo-1597452485669-2c7bb5fef90d?auto=format&fit=crop&q=80&w=600")!,
            explanation: "Hinge at the hips and grip the bar. Keep your back flat and shins close to the bar. Pull the weight by extending your hips and knees simultaneously."
        ),
        
        ExerciseType(
            name: "Overhead Press",
            icon: URL(string: "https://images.unsplash.com/photo-1541534741688-6078c64b52de?auto=format&fit=crop&q=80&w=600")!,
            explanation: "Press the barbell from your upper chest to full extension over your head. Tighten your core and glutes to prevent your lower back from arching."
        ),
        
        ExerciseType(
            name: "Pull-Ups",
            icon: URL(string: "https://images.unsplash.com/photo-1526506118085-60ce8714f8c5?auto=format&fit=crop&q=80&w=600")!,
            explanation: "Hang from a bar with an overhand grip. Pull your body up until your chin is over the bar, then lower yourself with control to a full hang."
        )
    ]
}

extension WorkoutItemVideo {
    
    static let allImages: [ImageResource] = [
        .workoutVideo1, .workoutVideo2, .workoutVideo3, .workoutVideo4, .workoutVideo5, .workoutVideo6
    ]
    
    static let sampleVideos: [WorkoutItemVideo] = (0..<30).map { _ in
        
        let randomDate = Calendar.current.date(
            byAdding: .day,
            value: -Int.random(in: 0...10),
            to: Date()
        )!
        
        return WorkoutItemVideo(
            video: URL(string: "https://www.aaa.com")!,
            thumbnail: allImages.randomElement()!,
            date: randomDate,
            exerciseType: .sample.randomElement() ?? .sample[0]
        )
    }
}

extension WorkoutItem {
    
    static let sampleData: [WorkoutItem] = (0..<6).map { _ in
        
        let randomDate = Calendar.current.date(
            byAdding: .day,
            value: -Int.random(in: 0...5),
            to: Date()
        )!

        let videosForThatDay = WorkoutItemVideo.sampleVideos.filter {
            Calendar.current.isDate($0.date, inSameDayAs: randomDate)
        }
        
        return WorkoutItem(
            thumbnail: videosForThatDay.first?.thumbnail ?? .workoutVideo1,
            date: randomDate,
            videos: videosForThatDay
        )
    }
}

extension Array where Element == WorkoutItemVideo {
    func videos(on date: Date, exerciseTypeName: String? = nil) -> [WorkoutItemVideo] {
        filter { video in
            let isSameDay = Calendar.current.isDate(video.date, inSameDayAs: date)
            let matchesExerciseType = exerciseTypeName == nil || video.exerciseType.name == exerciseTypeName
            return isSameDay && matchesExerciseType
        }
    }
}

extension Array where Element == WorkoutItem {
    func workoutItem(on date: Date) -> WorkoutItem? {
        first { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }

    mutating func addVideo(_ video: WorkoutItemVideo, thumbnail: ImageResource = .workoutVideo1) {
        if let index = firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: video.date) }) {
            self[index].videos.append(video)
        } else {
            let newItem = WorkoutItem(
                thumbnail: thumbnail,
                date: video.date,
                videos: [video]
            )
            append(newItem)
        }
    }
}
