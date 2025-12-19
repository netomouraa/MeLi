//
//  SearchView.swift
//  MeLi
//
//  Created by Neto Moura on 08/12/25.
//

import SwiftUI

// MARK: - Search View
struct SearchView: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Buscar productos...", text: $text)
                .textFieldStyle(.plain)
                .autocorrectionDisabled()
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(10)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding()
    }
}

