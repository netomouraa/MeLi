//
//  DetailContentView.swift
//  MeLi
//
//  Created by Neto Moura on 09/12/25.
//

import Foundation
import SwiftUI

struct DetailContentView: View {
    let detail: ProductDetail
    let description: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let pictures = detail.pictures, !pictures.isEmpty {
                TabView {
                    ForEach(pictures.prefix(5), id: \.url) { picture in
                        AsyncImage(url: URL(string: picture.url)) { image in
                            image.resizable().aspectRatio(contentMode: .fit)
                        } placeholder: {
                            Color.gray.opacity(0.3)
                        }
                    }
                }
                .frame(height: 300)
                .tabViewStyle(.page)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text(detail.title)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(detail.price.toCurrency())
                    .font(.title)
                    .foregroundColor(.green)
                
                HStack {
                    Label(detail.condition == "new" ? "Nuevo" : "Usado", systemImage: "tag")
                    if let quantity = detail.availableQuantity {
                        Text("• \(quantity) disponibles")
                    }
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                
                if let warranty = detail.warranty {
                    Label(warranty, systemImage: "checkmark.shield")
                        .font(.subheadline)
                }
                
                if let description = description, !description.isEmpty {
                    Divider()
                    Text("Descripción")
                        .font(.headline)
                    Text(description)
                        .font(.body)
                }
            }
            .padding()
        }
    }
}

