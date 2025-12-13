//
//  SearchView.swift
//  MeLi
//
//  Created by Neto Moura on 08/12/25.
//

import SwiftUI

struct SearchView: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Buscar productos...", text: $text)
                .textFieldStyle(.plain)
                .autocorrectionDisabled()
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(10)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding()
    }
}

struct ProductListView: View {
    let products: [Product]
    
    var body: some View {
        if products.isEmpty {
            EmptyStateView()
        } else {
            List(products) { product in
                NavigationLink(destination: ProductDetailView(productId: product.id)) {
                    ProductRowView(product: product)
                }
            }
            .listStyle(.plain)
        }
    }
}

struct ProductRowView: View {
    let product: Product
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: product.mainImage ?? "")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 80, height: 80)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .clipped()
                case .failure:
                    Image(systemName: "photo.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .foregroundColor(.gray)
                        .frame(width: 80, height: 80)
                        .background(Color(.systemGray6))
                @unknown default:
                    EmptyView()
                }
            }
            .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(product.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(2)
                    .foregroundColor(.primary)
                
            }
            .padding(.vertical, 8)
        }
    }
}


// MARK: - Empty State View
struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No se encontraron productos")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("Intenta buscar con otras palabras clave")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
