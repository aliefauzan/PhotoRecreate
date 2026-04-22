//
//  LoveButton.swift
//  PhotoRecreate
//
//  Created by Andi Muhammad Alief Fauzan on 18/04/26.
//

import SwiftUI

struct LoveButton: View {
    var body: some View {
        HStack {
            Spacer()
            Image(systemName: "heart")
                .foregroundColor(.white)
                .padding(15)
        }
    }
}

#Preview {
    LoveButton()
}
