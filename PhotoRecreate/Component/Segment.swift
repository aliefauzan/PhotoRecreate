//
//  Segments.swift
//  PhotoRecreate
//
//  Created by Muhammad Saleh Bagir Alatas on 17/04/26.
//

import SwiftUI

struct Segment: View {
    var images: [ImageResource] = [.photo10, .photo11, .photo12, .photo13, .photo14, .photo15]
    var title = "Memories"
    var cardType: CardType = .basic
    var workoutVideos: [WorkoutItemVideo] = WorkoutItemVideo.sampleVideos
    
    
    var body: some View {
        ScrollView(.vertical){
            VStack{
                HStack{
                    Text(title)
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                    
                    Button{
                        
                    }label: {
                        Image(systemName: "chevron.down")
                            .font(.system(size: 20, weight: .bold))
                            .padding(5)
                    }
                    .buttonStyle(.bordered)
                    .clipShape(Circle())
                }
                .padding(.horizontal)
                .padding(.top)
                ScrollView(.horizontal, showsIndicators: false){
                    HStack(spacing: 10){
                        ForEach(workoutVideos) {video in
                            NavigationLink {
                                DetailsWorkoutView(workoutItemVideo: video)
                            } label: {
                                PhotoCard(imageResource: video.thumbnail, cornerRadius: 25, cardType: cardType, text: video.exerciseType.name)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .scrollIndicators(.hidden)
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.viewAligned)
            }
        }
    }
}

#Preview {
    Segment()
}
