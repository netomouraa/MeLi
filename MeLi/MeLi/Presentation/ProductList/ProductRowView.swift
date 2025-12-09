//
//  ProductRowView.swift
//  MeLi
//
//  Created by Neto Moura on 08/12/25.
//

import Foundation
import SwiftUI

struct ProductRowView: View {
    let product: Product
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: product.thumbnail ?? "")) { image in
                image.resizable().aspectRatio(contentMode: .fit)
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 80, height: 80)
            .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(product.title)
                    .font(.subheadline)
                    .lineLimit(2)
                
                Text(product.price.toCurrency())
                    .font(.headline)
                    .foregroundColor(.green)
                
                Text(product.condition == "new" ? "Nuevo" : "Usado")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
