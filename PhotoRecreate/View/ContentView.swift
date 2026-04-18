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
            Tab("Library", systemImage: "photo.fill") {
                WorkoutView()
            }
            Tab("Collections", systemImage: "heart.fill") {
                Collections()
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
