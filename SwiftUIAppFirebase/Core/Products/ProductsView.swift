//
//  ProductsView.swift
//  SwiftUIAppFirebase
//
//  Created by Hakob Ghlijyan on 12/24/24.
//

import SwiftUI
import FirebaseFirestore

@MainActor
final class ProductsViewModel: ObservableObject {
    @Published private(set) var products: [Product] = []
    @Published var selectedFilter: FilterOption? = nil
    @Published var selectedCategoty: CategoryOption? = nil
    private var lastDocument: DocumentSnapshot? = nil

    func downloadProductsAndUploadToFirebase() {
        ProductsManager.shared.downloadProductsAndUploadToFirebase()
    }
        
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
        self.selectedFilter = option
        
        self.products = []
        self.lastDocument = nil
        
        self.getProducts()
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
        self.selectedCategoty = option

        self.products = []
        self.lastDocument = nil

        self.getProducts()
    }

    func getProducts() {
        Task {
            let (newProducts, lastDocument) = try await ProductsManager.shared.getAllProducts(
                priceDescending: selectedFilter?.priceDescending,
                forCategory: selectedCategoty?.categoryKey,
                count: 10,
                lastDocument: lastDocument
            )
            self.products.append(contentsOf: newProducts)
            if let lastDocument {
                self.lastDocument = lastDocument
            }
        }
    }
    
    func getProductsByRating() {
        Task {
            let (newProducts, lastDocument) = try await ProductsManager.shared.getProductsByRating(count: 2, lastDocument: lastDocument)
            
            self.products.append(contentsOf: newProducts)
            self.lastDocument = lastDocument
        }
    }
    
    func getProductCount() {
        Task {
            let count = try await ProductsManager.shared.getAllProductsCount()
            print("ALL PRODUCT COUNT: \(count)")
        }
    }
}

struct ProductsView: View {
    @StateObject private var viewModel: ProductsViewModel = ProductsViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.products) { product in
                ProductCellView(product: product)
                
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
