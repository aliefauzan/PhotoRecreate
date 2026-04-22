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
        Image(image)
            .resizable()
            .scaledToFill()
            .aspectRatio(contentMode: .fill)
            .clipped()
    }
}

#Preview {
    PhotoCardWithoutTitle(image: .workoutVideo1, cornerRadius: 25)
}
