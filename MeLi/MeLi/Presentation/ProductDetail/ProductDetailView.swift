//
//  ProductDetailView.swift
//  MeLi
//
//  Created by Neto Moura on 08/12/25.
//

import Foundation
import SwiftUI

struct ProductDetailView: View {
    let productId: String
    @StateObject private var viewModel = ProductDetailViewModel()
    
    var body: some View {
        ScrollView {
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
                    .padding()
            } else if let error = viewModel.errorMessage {
                ErrorView(message: error) {
                    viewModel.loadProduct(id: productId)
                }
            } else if let detail = viewModel.detail {
                DetailContentView(detail: detail, description: viewModel.description)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.loadProduct(id: productId)
        }
    }
}
