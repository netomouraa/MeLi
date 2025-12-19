//
//  LoadingView.swift
//  MeLi
//
//  Created by Neto Moura on 15/12/25.
//

import SwiftUI

// MARK: - Loading View
struct LoadingView: View {
    var body: some View {
        ProgressView("Cargando...")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
