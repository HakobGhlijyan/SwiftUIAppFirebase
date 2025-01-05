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
    @Published var selectedFilter: FilterOption? = nil
    @Published var selectedCategoty: CategoryOption? = nil

    func downloadProductsAndUploadToFirebase() {
        ProductsManager.shared.downloadProductsAndUploadToFirebase()
    }
    
//    func getAllProducts() async throws {
//        self.products = try await ProductsManager.shared.getAllProducts()
//    }
    
    enum FilterOption: String, CaseIterable {
        case noFilter
        case priceHigh
        case priceLow
        
        var priceDescending: Bool? {
            switch self {
            case .noFilter: return nil
            case .priceHigh: return true
            case .priceLow: return false
            }
        }
    }
    
    func filterSelected(option: FilterOption) async throws {
//        switch option {
//        case .noFilter:
//            self.products = try await ProductsManager.shared.getAllProducts()
//        case .priceHigh:
//            self.products = try await ProductsManager.shared.getAllProductsSortedByPrice(descending: true )
//        case .priceLow:
//            self.products = try await ProductsManager.shared.getAllProductsSortedByPrice(descending: false )
//        }
        self.selectedFilter = option
        self.getProduct()
    }
    
    enum CategoryOption: String, CaseIterable {
        case noCategory
        case furniture
        case beauty
        case groceries
        
        var categoryKey: String? {
            if self == .noCategory {
                return nil
            } else {
                return self.rawValue
            }
        }
    }
    
    func categotySelected(option: CategoryOption) async throws {
//        switch option {
//        case .noCategory:
//            self.products = try await ProductsManager.shared.getAllProducts()
//        case .furniture:
//            self.products = try await ProductsManager.shared.getAllProductsForCategory(category: option.rawValue)
//        case .beauty:
//            self.products = try await ProductsManager.shared.getAllProductsForCategory(category: option.rawValue)
//        case .groceries:
//            self.products = try await ProductsManager.shared.getAllProductsForCategory(category: option.rawValue)
//        }
        self.selectedCategoty = option
        self.getProduct()
    }
    
    func getProduct() {
        Task {
            self.products = try await ProductsManager.shared.getAllProducts(priceDescending: selectedFilter?.priceDescending, forCategory: selectedCategoty?.categoryKey )
        }
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
//        .task {
//            try? await viewModel.getAllProducts()
//        }
        .onAppear {
            viewModel.getProduct()
        }
    }
}

#Preview {
    NavigationStack {
        ProductsView()
    }
}
