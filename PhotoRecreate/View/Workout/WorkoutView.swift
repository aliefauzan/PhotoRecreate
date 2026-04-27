//
//  WorkoutView.swift
//  PhotoRecreate
//
//  Created by Andi Muhammad Alief Fauzan on 18/04/26.
//

import SwiftUI

struct WorkoutView: View {
    
    @State private var store = WorkoutStore()
    
    var body: some View {
        NavigationStack {
            VStack {
                
                HStack {
                    Text("My Workouts")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.horizontal)

                ScrollView {
                    VStack(spacing: 18) {
                        ForEach($store.workoutItems) { $item in
                            NavigationLink {
                                DailyWorkoutView(item: $item, store: store)
                            } label: {
                                WorkoutCardComponent(item: item)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                }
            }
            .background(Color(.systemGray6))
        }
    }
}

#Preview {
    WorkoutView()
}
