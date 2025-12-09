//
//  ErrorView.swift
//  MeLi
//
//  Created by Neto Moura on 08/12/25.
//

import Foundation
import SwiftUI

struct ErrorView: View {
    let message: String
    let retry: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.red)
            Text(message)
                .multilineTextAlignment(.center)
            Button("Reintentar", action: retry)
                .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
