//
//  EmptyStateView.swift
//  MeLi
//
//  Created by Neto Moura on 09/12/25.
//

import Foundation
import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            Text("Busca productos")
                .font(.title2)
            Text("Escribe al menos 3 caracteres")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}
