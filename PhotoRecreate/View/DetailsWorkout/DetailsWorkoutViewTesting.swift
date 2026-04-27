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
    var analysisResult: AnalysisResult?
    
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
                        
                        if let analysisResult {
                            Text(analysisResult.summaryFeedback)
                                .font(.body)
                                .foregroundColor(.secondary)
                        } else {
                            Text("Run an analysis from the Search tab to see AI feedback here.")
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
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
