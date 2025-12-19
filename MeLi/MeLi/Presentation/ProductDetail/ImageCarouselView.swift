//
//  ImageCarouselView.swift
//  MeLi
//
//  Created by Neto Moura on 15/12/25.
//

import SwiftUI

// MARK: - Image Carousel View
struct ImageCarouselView: View {
    let imageUrls: [String]
    var body: some View {
        Text("Carrossel de Imagens")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray.opacity(0.1))
    }
}
