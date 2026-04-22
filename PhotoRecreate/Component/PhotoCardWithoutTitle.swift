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
                .frame(maxWidth: .infinity)
                .aspectRatio(1, contentMode: .fill)
                .clipped()
        }
    }

#Preview {
    PhotoCardWithoutTitle(image: .photo10, cornerRadius: 25)
}
