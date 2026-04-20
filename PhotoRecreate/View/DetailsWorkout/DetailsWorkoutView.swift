//
//  DetailsWorkoutView.swift
//  PhotoRecreate
//
//  Created by Andi Muhammad Alief Fauzan on 18/04/26.
//

import SwiftUI

struct DetailsWorkoutView: View {
    
    @State private var selectedTab = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.gray.opacity(0.4))
                    .frame(height: 200)
                    .padding(.horizontal)
                
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
                        
                        Text("Bench Press")
                            .font(.title3)
                            .bold()
                        
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.gray.opacity(0.4))
                            .frame(height: 180)
                        
                        Text("""
                            Lie flat on the bench with your feet planted firmly on the ground.

                            Grip the bar slightly wider than shoulder-width apart. Lower the bar slowly to your chest while keeping your elbows at about a 45-degree angle.

                            Push the bar back up explosively while maintaining control.
                            """)
                        .font(.body)
                        .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.top)
        }
        .navigationTitle("Details Workout")
        .toolbarTitleDisplayMode(.inlineLarge)
    }
}

#Preview {
    NavigationStack {
        DetailsWorkoutView()
    }
}
