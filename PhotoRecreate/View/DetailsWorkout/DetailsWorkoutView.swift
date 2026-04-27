//
//  DetailsWorkoutView.swift
//  PhotoRecreate
//
//  Created by Andi Muhammad Alief Fauzan on 18/04/26.
//

import SwiftUI

struct DetailsWorkoutView: View {
    
    @State private var selectedTab = 0
    var workoutItemVideo: WorkoutItemVideo = .sampleVideos[0]
    var analysisResult: AnalysisResult?
    var thumbnailImage: UIImage?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let thumbImage = thumbnailImage ?? workoutItemVideo.thumbnailImage {
                    Image(uiImage: thumbImage)
                        .resizable()
                        .frame(height: 300)
                        .scaledToFill()
                        .clipped()
                } else {
                    Image(workoutItemVideo.thumbnail)
                        .resizable()
                        .frame(height: 300)
                        .scaledToFill()
                }
                
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
        DetailsWorkoutView()
    }
}
