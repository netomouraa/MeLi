//
//  ProductDetailViewModel.swift
//  MeLi
//
//  Created by Neto Moura on 08/12/25.
//

import Foundation
import Combine

final class ProductDetailViewModel: ObservableObject {
    @Published var detail: ProductDetail?
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
            repository.getDetail(id: id),
            repository.getDescription(id: id)
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
            self?.isLoading = false
            if case .failure(let error) = completion {
                self?.errorMessage = error.errorDescription
            }
        } receiveValue: { [weak self] detail, description in
            self?.detail = detail
            self?.description = description
        }
        .store(in: &cancellables)
    }
}

