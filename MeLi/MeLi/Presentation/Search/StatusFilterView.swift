//
//  StatusFilterView.swift
//  MeLi
//
//  Created by Neto Moura on 15/12/25.
//

import SwiftUI

// MARK: - Status Filter View
struct StatusFilterView: View {
    @Binding var selectedStatus: ProductStatus
    var body: some View {
        Text("Filtro: \(selectedStatus.rawValue.capitalized)")
            .font(.caption)
    }
}
