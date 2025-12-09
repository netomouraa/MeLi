//
//  ContentView.swift
//  MeLi
//
//  Created by Neto Moura on 08/12/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = SearchViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                SearchView(text: $viewModel.searchText)
                
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                } else if let error = viewModel.errorMessage {
                    ErrorView(message: error) {
                        viewModel.errorMessage = nil
                    }
                } else {
                    ProductListView(products: viewModel.products)
                }
            }
            .navigationTitle("Mercado Libre")
        }
        .navigationViewStyle(.stack)
    }
}
