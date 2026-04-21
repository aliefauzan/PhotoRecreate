//
//  CollectionsAlief.swift
//  PhotoRecreate
//
//  Created by Andi Muhammad Alief Fauzan on 18/04/26.
//
import SwiftUI

struct DailyWorkoutView: View {
    let item: WorkoutItem
    var workoutVideosGrouped : [String : [WorkoutItemVideo]] {
        Dictionary(grouping: WorkoutItemVideo.sampleVideos, by: {$0.exerciseType.name})
    }

    
    var body: some View {
        NavigationStack {
            ScrollView {
                
                ForEach(workoutVideosGrouped.keys.sorted(), id: \.self) {category in
                    Segment(title: category, cardType: .noTitle, workoutVideos: workoutVideosGrouped[category]!)
                }
            }
            .navigationTitle(item.title)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

#Preview {
    DailyWorkoutView(item : WorkoutItem.sampleData[0])
}
