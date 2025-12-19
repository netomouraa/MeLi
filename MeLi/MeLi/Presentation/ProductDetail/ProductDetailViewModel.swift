//
//  ProductDetailViewModel.swift
//  MeLi
//
//  Created by Neto Moura on 08/12/25.
//

import Foundation
import Combine

// MARK: - Product Detail View Model
final class ProductDetailViewModel: ObservableObject {
    @Published var catalogDetail: ProductCatalogDetail?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let repository: ProductRepositoryProtocol
    private let authManager: AuthenticationManager
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: ProductRepositoryProtocol = ProductRepository(),
         authManager: AuthenticationManager = .shared) {
        self.repository = repository
        self.authManager = authManager
    }
    
    func loadProduct(id: String) {
        guard let token = authManager.getToken() else {
            errorMessage = "Token no disponible. Autenticando..."
            authManager.authenticate()
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        repository.getCatalogDetail(id: id, token: token)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.errorDescription
                }
            } receiveValue: { [weak self] catalogDetail in
                self?.catalogDetail = catalogDetail
            }
            .store(in: &cancellables)
    }
}
