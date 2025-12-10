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
    private var accessToken: String?
    
    init(repository: ProductRepositoryProtocol = ProductRepository()) {
        self.repository = repository
        setupSearch()
        authenticateOnInit()
    }
    
    // MARK: - Authenticate on App Start
    private func authenticateOnInit() {
        repository.authenticate()
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    print("⚠️ Auth error: \(error.localizedDescription)")
                    self?.errorMessage = "Error de autenticación. Verifica las credenciales."
                }
            } receiveValue: { [weak self] token in
                print("✅ Token obtenido: \(token.prefix(20))...")
                self?.accessToken = token
            }
            .store(in: &cancellables)
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
        guard let token = accessToken else {
            errorMessage = "Autenticando... Intenta de nuevo en un momento."
            authenticateOnInit()
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        repository.search(query: query, siteId: "MLA", token: token)
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
