//
//  ProductsView.swift
//  SwiftUIAppFirebase
//
//  Created by Hakob Ghlijyan on 12/24/24.
//

import SwiftUI
import FirebaseFirestore

struct ProductsView: View {
    @StateObject private var viewModel: ProductsViewModel = ProductsViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.products) { product in
                ProductCellView(product: product)
                    .contextMenu {
                        Button("Add To Favorite") {
                            viewModel.addUserFavoriteProduct(productID: product.id)
                        }
                    }
                
                if product == viewModel.products.last {
                    ProgressView()
                        .onAppear {
                            viewModel.getProducts()
                        }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Menu("Filter: \(viewModel.selectedFilter?.rawValue ?? "NONE")") {
                    ForEach(ProductsViewModel.FilterOption.allCases , id: \.self) { filterOption in
                        Button(filterOption.rawValue) {
                            Task {
                                try? await viewModel.filterSelected(option: filterOption)
                            }
                        }
                    }
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Menu("Filter: \(viewModel.selectedCategoty?.rawValue ?? "NONE")") {
                    ForEach(ProductsViewModel.CategoryOption.allCases , id: \.self) { categoryOption in
                        Button(categoryOption.rawValue) {
                            Task {
                                try? await viewModel.categotySelected(option: categoryOption)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Products")
        .onAppear {
            viewModel.getProducts()
            viewModel.getProductCount()
            
        }
    }
}

#Preview {
    NavigationStack {
        ProductsView()
    }
}
