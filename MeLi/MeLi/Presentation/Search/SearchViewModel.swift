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
    @Published var selectedStatus: ProductStatus = .active
    
    private let repository: ProductRepositoryProtocol
    private let authManager: AuthenticationManager
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: ProductRepositoryProtocol = ProductRepository(),
         authManager: AuthenticationManager = .shared) {
        self.repository = repository
        self.authManager = authManager
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
        guard let token = authManager.getToken() else {
            errorMessage = "Autenticando... Intenta de nuevo en un momento."
            authManager.authenticate()
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        repository.search(query: query, siteId: "MLA", status: selectedStatus, token: token)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.errorDescription
                }
            } receiveValue: { [weak self] response in
                self?.products = response.results
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Public Methods
    func refreshSearch() {
        if !searchText.isEmpty && searchText.count >= 3 {
            performSearch(query: searchText)
        }
    }
    
    func clearResults() {
        products = []
        searchText = ""
        errorMessage = nil
    }
    
    func changeStatus(_ status: ProductStatus) {
        selectedStatus = status
        if !searchText.isEmpty && searchText.count >= 3 {
            performSearch(query: searchText)
        }
    }
}



