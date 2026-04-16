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
                VStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 14) {
                            
                            ForEach(0..<5) { _ in
                                PhotoCardsView(
                                    image: Image(.photo10),
                                    title: "Denpasar",
                                    date: "11 APR 2026"
                                )
                            }
                        }
                        
                        .padding(14)
                        Spacer()
                            .padding(.horizontal)
                        
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 14) {
                            
                            ForEach(0..<5) { _ in
                                PhotoCardsView(
                                    image: Image(.photo10),
                                    title: "Denpasar",
                                    date: "11 APR 2026"
                                )
                            }
                        }
                        
                        .padding(14)
                        Spacer()
                            .padding(.horizontal)
                        
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 14) {
                            
                            ForEach(0..<5) { _ in
                                PhotoCardsView(
                                    image: Image(.photo10),
                                    title: "Denpasar",
                                    date: "11 APR 2026"
                                )
                            }
                        }
                        
                        .padding(14)
                        Spacer()
                            .padding(.horizontal)
                        
                    }
                }
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
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
                        // profile action
                    } label: {
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
