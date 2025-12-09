//
//  ProductListView.swift
//  MeLi
//
//  Created by Neto Moura on 08/12/25.
//

import Foundation
import SwiftUI

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
