//
//  ProductsManager.swift
//  SwiftUIAppFirebase
//
//  Created by Hakob Ghlijyan on 12/24/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore

final class ProductsManager {
    static let shared = ProductsManager()
    private init() {}
    //MARK: - productCollection
    private let productCollection = Firestore.firestore().collection("SwiftUIAppFirebase_Products")
    //MARK: - productDocument
    private func productDocument(productID: String) -> DocumentReference {
        productCollection
            .document(productID)
    }
    //MARK: - UPLOAD
    func uploadProduct(product: Product) async throws {
        try productDocument(productID: String(product.id))
            .setData(from: product, merge: false)
    }
    //MARK: - GET ONE PRODUCT
    func getProduct(productID: String) async throws -> Product {
        try await productDocument(productID: productID)
            .getDocument(as: Product.self)
    }
    //MARK: - GET ALL ARRAY PRODUCT
    private func getAllProducts() async throws -> [Product] {
        try await productCollection
            .getDocumentsT(as: Product.self)
    }
    //MARK: -  GET ALL ARRAY PRODUCT BY SORT
    private func getAllProductsSortedByPrice(descending: Bool) async throws -> [Product] {
        try await productCollection
            .order(by: Product.CodingKeys.price.rawValue, descending: descending)
            .getDocumentsT(as: Product.self)
    }
    //MARK: -  GET ALL ARRAY PRODUCT BY FILTER (Where -> .... )
    private func getAllProductsForCategory(category: String) async throws -> [Product] {
        try await productCollection
            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
            .getDocumentsT(as: Product.self)
    }
    
    //MARK: -  GET ALL ARRAY PRODUCT BY FILTER (Where -> .... )
    private func getAllProductsByPriceAndCategory(descending: Bool, category: String) async throws -> [Product] {
        try await productCollection
            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
            .order(by: Product.CodingKeys.price.rawValue, descending: descending)
            .getDocumentsT(as: Product.self)
    }
    
    //MARK: - GET ALL ARRAY PRODUCT , BY OPTION IS UP PRIVATE FUNC
    func getAllProducts(priceDescending descending: Bool?, forCategory category: String?) async throws -> [Product] {
        if let descending, let category {
            return try await getAllProductsByPriceAndCategory(descending: descending, category: category)
        } else if let descending {
            return try await getAllProductsSortedByPrice(descending: descending)
        } else if let category {
            return try await getAllProductsForCategory(category: category)
        }
        return try await getAllProducts()
    }
    
}

extension Query {
    //MARK: -  UNIVERSAL FUNC FOR IN -> ALL TYPE DECODABLE AND GET SAPSHOT -> DECODE MAP IN DOCUEMTS ARRAY FOR RETURN
    func getDocumentsT<T>(as type: T.Type) async throws -> [T] where T: Decodable {
        let snapshot = try await self.getDocuments()
        return try snapshot.documents.map { document in
            try document.data(as: T.self)
        }
    }
}

extension ProductsManager {
    //MARK: -  GET ALL ARRAY PRODUCT -> Dowload product by url and upload firestore , first time.
    func downloadProductsAndUploadToFirebase() {
        guard let url = URL(string: "https://dummyjson.com/products") else { return }
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let products = try JSONDecoder().decode(ProductArray.self, from: data)
                let productArray = products.products
                
                for product in productArray {
                    try? await ProductsManager.shared.uploadProduct(product: product)
                }
                
                print("SUCCESS")
                print(products.products.count)
            } catch {
                print(error)
            }
        }
    }
}
