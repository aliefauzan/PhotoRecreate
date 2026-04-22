//
//  PhotoCards.swift
//  PhotoRecreate
//
//  Created by Andi Muhammad Alief Fauzan on 15/04/26.
//

import SwiftUI

struct PhotoCardsView: View {
    var image: Image
    var title: String
    var date: String

    var body: some View {
        ZStack {
            // Background Image
            image
                .resizable()
                .scaledToFill()
                .frame(width: 250, height: 300)
                .clipped()

            // Gradient overlay
            LinearGradient(
                colors: [Color.clear, Color.black.opacity(0.7)],
                startPoint: .center,
                endPoint: .bottom
            )
            .frame(width: 250, height: 300)

            VStack {
                // Top right heart
                HStack {
                    Spacer()
                    Image(systemName: "heart")
                        .foregroundColor(.white)
                        .padding(15)
                }

                Spacer()

                // Bottom content
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.title3)
                            .bold()
                            .foregroundColor(.white)

                        Text(date)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }

                    Spacer()

                    // Play button
                    Image(systemName: "play.fill")
                        .foregroundColor(.white)
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                }
                .padding()
            }
            .frame(width: 250, height: 300)
        }
        .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
    }
}

#Preview {
    PhotoCardsView(
        image: Image(.photo10),
        title: "Denpasar",
        date: "11 APR 2026"
    )
}
