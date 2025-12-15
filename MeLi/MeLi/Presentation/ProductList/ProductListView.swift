//
//  ProductListView.swift
//  MeLi
//
//  Created by Neto Moura on 08/12/25.
//

import SwiftUI

// MARK: - ProductListView
struct ProductListView: View {
    let products: [Product]
    
    var body: some View {
        if products.isEmpty {
            EmptyStateView()
        } else {
            List(products) { product in
                // 3. Detalhe de um Produto (Navegação para Tela 3)
                NavigationLink(destination: ProductDetailView(productId: product.id)) {
                    ProductRowView(product: product)
                }
            }
            .listStyle(.plain)
        }
    }
}
