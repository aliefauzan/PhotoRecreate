//
//  CollectionsAlief.swift
//  PhotoRecreate
//
//  Created by Andi Muhammad Alief Fauzan on 18/04/26.
//
import SwiftUI

struct DailyWorkoutView: View {
    @State private var item: WorkoutItem

    init(item: WorkoutItem) {
        _item = State(initialValue: item)
    }

    var groupedVideos: [String: [WorkoutItemVideo]] {
        Dictionary(grouping: item.videos, by: { $0.exerciseType.name })
    }

    var body: some View {
        NavigationStack {
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
                        addNewWorkoutItemVideo()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

extension DailyWorkoutView {
    private func addNewWorkoutItemVideo() {
        let randomExercise = ExerciseType.sample.randomElement() ?? ExerciseType.sample[0]

        let newVideo = WorkoutItemVideo(
            video: URL(string: "https://example.com/dummy-video.mp4")!,
            thumbnail: WorkoutItemVideo.allImages.randomElement() ?? .workoutVideo1,
            date: item.date,
            exerciseType: randomExercise
        )

        item.videos.append(newVideo)
    }
}

#Preview {
    DailyWorkoutView(item: WorkoutItem.sampleData[0])
}
