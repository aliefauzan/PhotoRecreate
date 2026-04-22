//
//  ToolBar.swift
//  PhotoRecreate
//
//  Created by Andi Muhammad Alief Fauzan on 15/04/26.
//

import SwiftUI

struct ToolBar: View {
    let title: String
    let ToolBarA: String
    let ToolBarB: String
    
    var body: some View {
        NavigationStack {
            ScrollView {
            }
            
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Image(systemName: ToolBarA)
                }
                ToolbarSpacer(placement: .topBarTrailing)
                ToolbarItem(placement: .topBarTrailing) {
                    Text(ToolBarB)
                        .padding()
                }
                
            }
            .toolbarTitleDisplayMode(.inlineLarge)
    }
       
    }
}

#Preview {
    ToolBar(title: "String", ToolBarA: "line.3.horizontal.decrease", ToolBarB: "Select")
}
