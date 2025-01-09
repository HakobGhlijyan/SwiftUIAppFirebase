//
//  ProductCellViewBuilder.swift
//  SwiftUIAppFirebase
//
//  Created by Hakob Ghlijyan on 1/9/25.
//

import SwiftUI

struct ProductCellViewBuilder: View {
    @State private var product: Product? = nil
    let productID: String
    
    var body: some View {
        ZStack {
            if let product {
                ProductCellView(product: product)
            }
        }
        .task {
            self.product = try? await ProductsManager.shared.getProduct(productID: productID)
        }
    }
}

#Preview {
    ProductCellViewBuilder(productID: "1")
}
