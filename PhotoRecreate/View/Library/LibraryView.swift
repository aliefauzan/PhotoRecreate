//
//  Library.swift
//  PhotoRecreate
//
//  Created by Antonio Palomba on 15/04/26.
//

import SwiftUI

struct LibraryView: View {
    
    let grids: [GridItem] = [
        GridItem(.adaptive(minimum: 120), spacing: 1)
    ]
    
    let videos = WorkoutItemVideo.sampleVideos
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: grids, spacing: 1) {
                    
                    ForEach(videos) { video in
                        NavigationLink {
                            DetailsWorkoutView(workoutItemVideo: video)
                        } label: {
                            PhotoCardWithoutTitle(image: video.thumbnail,cornerRadius: 0)
                        }
                            
                    }
                }
            }
            .navigationTitle("Library")
            .toolbarTitleDisplayMode(.inlineLarge)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Image(systemName: "line.3.horizontal.decrease")
                }
                ToolbarSpacer(placement: .topBarTrailing)
                
                ToolbarItem(placement: .topBarTrailing) {
                    Text("Select")
                }
            }
        }
    }
}

#Preview {
    LibraryView()
}

