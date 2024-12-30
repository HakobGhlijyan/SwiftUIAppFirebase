//
//  ProductsView.swift
//  SwiftUIAppFirebase
//
//  Created by Hakob Ghlijyan on 12/24/24.
//

import SwiftUI

@MainActor
final class ProductsViewModel: ObservableObject {
    @Published private(set) var products: [Product] = []

    func downloadProductsAndUploadToFirebase() {
        ProductsManager.shared.downloadProductsAndUploadToFirebase()
    }
    
    func getAllProducts() async throws {
        self.products = try await ProductsManager.shared.getAllProducts()
    }
}

struct ProductsView: View {
    @StateObject private var viewModel: ProductsViewModel = ProductsViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.products) { product in
                ProductCellView(product: product)
            }
        }
        .navigationTitle("Products")
        .task {
            try? await viewModel.getAllProducts()
        }
    }
}

#Preview {
    NavigationStack {
        ProductsView()
    }
}
