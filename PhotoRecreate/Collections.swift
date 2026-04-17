//
//  Collections.swift
//  PhotoRecreate
//
//  Created by Andi Muhammad Alief Fauzan on 15/04/26.
//

import SwiftUI

struct Collections: View {
    var body: some View {
        NavigationStack {
            ScrollView{
                Segment(title: "Memory", cardType: .memory)
                Segment(title: "Pinned", cardType: .basic)
                Segment(title: "Albums", cardType: .basic)
                Segment(title: "People", cardType: .basic)
                Segment(title: "Featured Photos", cardType: .basic)
            }
            
            .navigationTitle("Collections")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { }) {
                        Image(systemName: "ellipsis")
                    }
                }
                ToolbarSpacer(placement: .topBarTrailing)
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        
                    } label : {
                        Image(systemName: "person.fill")
                            .foregroundStyle(.blue)
                        
                        
                        
                    }
                    
                }
                
                
            }
            .toolbarTitleDisplayMode(.inlineLarge)
        }
   }
    
}

#Preview {
    Collections()
}
