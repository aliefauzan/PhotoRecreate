//
//  PhotoCardWithTitle.swift
//  PhotoRecreate
//
//  Created by Muhammad Saleh Bagir Alatas on 17/04/26.
//

import SwiftUI

struct PhotoCardWithoutTitle: View {
    let image: ImageResource
    let cornerRadius: CGFloat
    
    var body: some View {
        Rectangle()
     
            .aspectRatio(1, contentMode: .fit)
            .overlay {
                Image(image)
                    .resizable()
                    .scaledToFill()
            }
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

#Preview {
    PhotoCardWithoutTitle(image: .workoutVideo1, cornerRadius: 25)
}
