//
//  ProductDetailViewModel.swift
//  MeLi
//
//  Created by Neto Moura on 08/12/25.
//

import Foundation
import Combine

enum NetworkError: Error {
    case invalidURL
    case network(Error)
    case decodingError
    case custom(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "URL inválida."
        case .network(let error): return "Erro de rede: \(error.localizedDescription)"
        case .decodingError: return "Erro ao decodificar a resposta do servidor."
        case .custom(let message): return message
        }
    }
}

final class ProductDetailViewModel: ObservableObject {
    @Published var catalogDetail: ProductCatalogDetail?
    @Published var itemDetail: ProductDetail?
    @Published var description: String?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let repository: ProductRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: ProductRepositoryProtocol = ProductRepository()) {
        self.repository = repository
    }
    
    func loadProduct(id: String) {
        isLoading = true
        errorMessage = nil
        
        Publishers.Zip(
            repository.getCatalogDetail(id: id),
//            repository.getDetail(id: id), // Assumindo que este busca o preço/condição
            repository.getDescription(id: id)
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
            self?.isLoading = false
            if case .failure(let error) = completion {
                self?.errorMessage = error.errorDescription
            }
        } receiveValue: { [weak self] catalogDetail, description in
            self?.catalogDetail = catalogDetail
            self?.description = description
        }
        .store(in: &cancellables)
    }
}
