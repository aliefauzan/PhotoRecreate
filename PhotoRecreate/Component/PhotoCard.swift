//
//  PhotoCard.swift
//  PhotoRecreate
//
//  Created by Muhammad Saleh Bagir Alatas on 15/04/26.
//

import SwiftUI
enum CardType {
    case noTitle, memory, basic
}


struct PhotoCard: View {
    var imageResource: ImageResource = .photo10
    var cornerRadius: CGFloat
    var cardType: CardType = .memory
    var text = "some title"
    
    
    
    var body: some View {
        
        ZStack(alignment: .bottomLeading){
            Image(imageResource)
                .resizable()
                .scaledToFill()
                .frame(height: cardType == .memory ? 300 : 150)
                .frame(width: cardType == .memory ? 300 : 150)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))

            VStack(alignment: .leading){
                switch(cardType) {
                case .memory:
                    Text(text)
                        .foregroundStyle(.white)
                        .fontWeight(.heavy)
                        .font(.title2)
                    
                    Text("21 Mar 2026")
                        .foregroundStyle(.white)
                case .basic:
                    Text(text)
                        .foregroundStyle(.white)
                        .bold()
                default:
                    EmptyView()
                }
            }
            .padding()
        }
    }
}

#Preview {
    PhotoCard(cornerRadius: 25)
}
