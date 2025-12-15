//
//  AuthenticationManager.swift
//  MeLi
//
//  Created by Neto Moura on 15/12/25.
//

import Foundation
import Combine

final class AuthenticationManager: ObservableObject {
    @Published private(set) var accessToken: String?
    @Published private(set) var isAuthenticated = false
    @Published var errorMessage: String?
    
    private let repository: ProductRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    static let shared = AuthenticationManager()
    
    init(repository: ProductRepositoryProtocol = ProductRepository()) {
        self.repository = repository
        authenticateOnInit()
    }
    
    // MARK: - Authenticate on App Start
    private func authenticateOnInit() {
        authenticate()
    }
    
    func authenticate() {
        repository.authenticate()
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    print("⚠️ Auth error: \(error.localizedDescription)")
                    self?.errorMessage = "Error de autenticación. Verifica las credenciales."
                    self?.isAuthenticated = false
                }
            } receiveValue: { [weak self] token in
                print("✅ Token obtenido: \(token.prefix(20))...")
                self?.accessToken = token
                self?.isAuthenticated = true
            }
            .store(in: &cancellables)
    }
    
    func getToken() -> String? {
        return accessToken
    }
}
