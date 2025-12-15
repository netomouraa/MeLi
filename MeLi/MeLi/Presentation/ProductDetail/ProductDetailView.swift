//
//  ProductDetailView.swift
//  MeLi
//
//  Created by Neto Moura on 08/12/25.
//

import SwiftUI

// MARK: - Product Detail View
struct ProductDetailView: View {
    @StateObject var viewModel: ProductDetailViewModel
    let productId: String
    
    init(productId: String) {
        self.productId = productId
        _viewModel = StateObject(wrappedValue: ProductDetailViewModel())
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                LoadingView()
            } else if let detail = viewModel.catalogDetail {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        ImageCarouselView(imageUrls: detail.imageUrls)
                            .frame(height: 300)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text(detail.name)
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        .padding(.horizontal)
                        
                        Divider()

                        .padding(.horizontal)
                        
                        Spacer()
                    }
                }
                .navigationTitle(detail.familyName ?? "Detalle del Producto")
                .navigationBarTitleDisplayMode(.inline)
            } else {
                ErrorView(message: viewModel.errorMessage ?? "No se pudo cargar el detalle del producto.")
            }
        }
        .onAppear {
            viewModel.loadProduct(id: productId)
        }
    }
}

