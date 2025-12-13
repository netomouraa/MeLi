//
//  ProductDetailView.swift
//  MeLi
//
//  Created by Neto Moura on 08/12/25.
//

import SwiftUI
import Combine

import SwiftUI

// Assumindo que todos os modelos e Views auxiliares (LoadingView, ErrorView, ImageCarouselView,
// DetailContentView, PickersView, KeyAttributesView, SpecificationAttributesView)
// estão definidos e disponíveis.

struct ProductDetailView: View {
    @StateObject var viewModel: ProductDetailViewModel
    let productId: String
    
    init(productId: String) {
        self.productId = productId
        _viewModel = StateObject(wrappedValue: ProductDetailViewModel())
    }
    
    var body: some View {
//        Group {
//            if viewModel.isLoading {
//                LoadingView()
//            } else if let detail = viewModel.catalogDetail {
//                ScrollView {
//                    VStack(alignment: .leading, spacing: 20) {
//                        ImageCarouselView(imageUrls: detail.imageUrls)
//                            .frame(height: 300)
//                        
//                        VStack(alignment: .leading, spacing: 10) {
//                            Text(detail.name)
//                                .font(.title2)
//                                .fontWeight(.bold)
////                            if let itemDetail = viewModel.itemDetail {
////                                DetailContentView(itemDetail: itemDetail)
////                                    .padding(.vertical, 5)
////                            }
//                            
//                        }
//                        .padding(.horizontal)
//                        
//                        Divider()
//                        
//                        if let description = viewModel.description, !description.isEmpty {
//                            VStack(alignment: .leading, spacing: 8) {
//                                Text("Descripción")
//                                    .font(.headline)
//                                Text(description)
//                                    .font(.body)
//                            }
//                            .padding(.horizontal)
//                            Divider()
//                        }
//                        
//                        VStack(alignment: .leading, spacing: 15) {
//                            Text("Especificaciones Técnicas")
//                                .font(.headline)
//                            
//                            KeyAttributesView(attributes: detail.keyAttributes)
//                            
////                            if !detail.specificationAttributes.isEmpty {
////                                DisclosureGroup("Ver todos los detalles") {
////                                    SpecificationAttributesView(attributes: detail.specificationAttributes)
////                                }
////                                .tint(.blue)
////                            }
//                        }
//                        .padding(.horizontal)
//                        
//                        Spacer()
//                    }
//                }
//                .navigationTitle(detail.familyName ?? "Detalle del Producto")
//                .navigationBarTitleDisplayMode(.inline)
//            } else {
//                ErrorView(message: viewModel.errorMessage ?? "No se pudo cargar el detalle del producto.")
//            }
//        }
//        .onAppear {
//            viewModel.loadProduct(id: productId)
//        }
    }
}


struct ImageCarouselView: View {
    let imageUrls: [String]
    
    var body: some View {
        TabView {
            ForEach(imageUrls, id: \.self) { urlString in
                AsyncImage(url: URL(string: urlString)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    case .failure:
                        Image(systemName: "photo.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}


struct ErrorView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 60))
                .foregroundColor(.red)
            
            Text("Ocurrió un Error")
                .font(.title2)
                .foregroundColor(.primary)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
