//
//  WorkoutView.swift
//  PhotoRecreate
//
//  Created by Andi Muhammad Alief Fauzan on 18/04/26.
//

import SwiftUI

struct WorkoutView: View {
    
    let data: [WorkoutItem] = [
        .init(title: "Today", videos: 7),
        .init(title: "Sunday", videos: 4),
        .init(title: "4 April", videos: 5),
        .init(title: "3 April", videos: 5),
        .init(title: "1 April", videos: 5),
        .init(title: "30 March", videos: 5),
        .init(title: "29 March", videos: 5),
        .init(title: "29 March", videos: 5),
        .init(title: "29 March", videos: 5),
        .init(title: "29 March", videos: 5),
        .init(title: "29 March", videos: 5),
        .init(title: "29 March", videos: 5),
        .init(title: "29 March", videos: 5),
    ]
    
    var body: some View {
        VStack {
            HStack {
                
                Text("My Workouts")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.horizontal)
            
            ScrollView{
                VStack(spacing: 18) {
                    ForEach(data) { item in
                        WorkoutCardComponent(item: item)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
            }
            
        }
        
        .background(Color(.systemGray6))
    }
}

#Preview {
    WorkoutView()
}
