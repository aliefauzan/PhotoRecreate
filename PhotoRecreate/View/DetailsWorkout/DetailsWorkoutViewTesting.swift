//
//  DetailsWorkoutViewDetailsWorkoutViewTesting.swift
//  PhotoRecreate
//
//  Created by Andi Muhammad Alief Fauzan on 22/04/26.
//

import SwiftUI
import AVKit

struct DetailsWorkoutViewTesting: View {
    
    @State private var selectedTab = 0
    var workoutItemVideo: WorkoutItemVideo = .sampleVideos[1]
    
    @State private var player = AVPlayer(url: Bundle.main.url(forResource: "IMG_2530", withExtension: "MOV")!)
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                VideoPlayer(player: player)
                    .frame(height: 300)
                    
                
                Picker("", selection: $selectedTab) {
                    Text("Feedback").tag(0)
                    Text("How to").tag(1)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                if selectedTab == 0 {
                    
                    VStack(alignment: .leading, spacing: 12) {
                        
                        HStack {
                            Image(systemName: "sparkles")
                            Text("AI Feedback")
                                .font(.headline)
                        }
                        
                        Text("""
                            Your form is generally good, but your elbows are slightly flaring out during the movement. Try to keep them more tucked to reduce shoulder strain.

                            Also, control the eccentric (lowering) phase more slowly to improve muscle engagement and stability.
                            """)
                        .font(.body)
                        .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    
                } else {
                    VStack(alignment: .leading, spacing: 16) {
                        
                        AsyncImage(url: workoutItemVideo.exerciseType.icon)
                        
                        Text(workoutItemVideo.exerciseType.explanation)
                        .font(.body)
                        .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.top)
        }
        .navigationTitle(workoutItemVideo.exerciseType.name)
        .toolbarTitleDisplayMode(.inlineLarge)
    }
}

#Preview {
    NavigationStack {
        DetailsWorkoutViewTesting()
    }
}
