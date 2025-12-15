//
//  EmptyStateView.swift
//  MeLi
//
//  Created by Neto Moura on 09/12/25.
//

import SwiftUI

// MARK: - Empty State View
struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No se encontraron productos")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("Intenta buscar con otras palabras clave")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
