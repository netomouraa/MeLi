//
//  ContentView.swift
//  MeLi
//
//  Created by Neto Moura on 08/12/25.
//
import SwiftUI
import Combine

// MARK: - Content View
struct ContentView: View {
    @StateObject private var searchViewModel = SearchViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                SearchView(text: $searchViewModel.searchText)
  
                ZStack {
                    ProductListView(products: searchViewModel.products)
                    
                    if searchViewModel.isLoading {
                        LoadingView()
                    }
                }
            }
            .navigationTitle("Buscar Produtos")
            .navigationBarTitleDisplayMode(.large)
            .alert("Error", isPresented: .constant(searchViewModel.errorMessage != nil)) {
                Button("OK") { searchViewModel.errorMessage = nil }
            } message: {
                Text(searchViewModel.errorMessage ?? "")
            }
        }
    }
}
