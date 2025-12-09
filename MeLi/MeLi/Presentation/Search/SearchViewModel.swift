//
//  SearchViewModel.swift
//  MeLi
//
//  Created by Neto Moura on 08/12/25.
//

import Foundation
import Combine

final class SearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var products: [Product] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let repository: ProductRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: ProductRepositoryProtocol = ProductRepository()) {
        self.repository = repository
        setupSearch()
    }
    
    private func setupSearch() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .filter { $0.count >= 3 }
            .sink { [weak self] query in
                self?.performSearch(query: query)
            }
            .store(in: &cancellables)
    }
    
    private func performSearch(query: String) {
        isLoading = true
        errorMessage = nil
        
        repository.search(query: query, siteId: "MLA")
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.errorDescription
                }
            } receiveValue: { [weak self] products in
                self?.products = products
            }
            .store(in: &cancellables)
    }
}

