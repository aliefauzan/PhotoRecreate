//
//  PhotoCardWithTitle.swift
//  PhotoRecreate
//
//  Created by Muhammad Saleh Bagir Alatas on 17/04/26.
//

import SwiftUI

struct PhotoCardWithTitle: View {
    var body: some View {
        ZStack{
            PhotoCard(cardType: .noTitle)
        }
    }
}

#Preview {
    PhotoCardWithTitle()
}
