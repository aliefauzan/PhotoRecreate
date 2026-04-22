//
//  ContentView.swift
//  PhotoRecreate
//
//  Created by Antonio Palomba on 15/04/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Workout", systemImage: "dumbbell.fill") {
                WorkoutView()
            }
            Tab("Library", systemImage: "photo") {
                LibraryView()
            }
            Tab(role: .search){
                SearchView()
            }
            
        }
            
    }
}

#Preview {
    ContentView()
}
