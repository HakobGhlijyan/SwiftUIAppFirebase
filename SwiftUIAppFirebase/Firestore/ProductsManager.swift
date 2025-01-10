//
//  ProductsManager.swift
//  SwiftUIAppFirebase
//
//  Created by Hakob Ghlijyan on 12/24/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import Combine

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
    //0. - ALL PRODUCT
    private func getAllProductsQuery() -> Query {
        productCollection
    }
    //2. - PRODUCT BY SORT
    private func getAllProductsSortedByPriceQuery(descending: Bool) -> Query {
        productCollection
            .order(by: Product.CodingKeys.price.rawValue, descending: descending)
    }
    //3. - PRODUCT BY FILTER
    private func getAllProductsForCategoryQuery(category: String) -> Query {
        productCollection
            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
    }
    
    //1. - PRODUCT BY SORT AND FILTER
    private func getAllProductsByPriceAndCategoryQuery(descending: Bool, category: String) -> Query {
        productCollection
            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
            .order(by: Product.CodingKeys.price.rawValue, descending: descending)
    }
    
    //MARK: - GET ALL ARRAY PRODUCT , BY OPTION IS UP PRIVATE FUNC
    //4 - IN COUNT , IN LAST
    func getAllProducts(priceDescending descending: Bool?, forCategory category: String?, count: Int, lastDocument: DocumentSnapshot?) async throws -> (product: [Product], lastDocument: DocumentSnapshot?) {
        var query: Query = getAllProductsQuery()
        
        if let descending, let category {
            query = getAllProductsByPriceAndCategoryQuery(descending: descending, category: category)
        } else if let descending {
            query = getAllProductsSortedByPriceQuery(descending: descending)
        } else if let category {
            query = getAllProductsForCategoryQuery(category: category)
        }
         
        return try await query
            .startOptionally(afterDocument: lastDocument)
            .getDocumentsWithSnapshotT(as: Product.self)
    }
    
    //MARK: - PRODUCT BY RATING
    func getProductsByRating(count: Int, lastDocument: DocumentSnapshot?) async throws -> (product: [Product], lastDocument: DocumentSnapshot?) {
        if let lastDocument {
            return try await productCollection
                .order(by: Product.CodingKeys.rating.rawValue, descending: true)
                .limit(to: count)
                .start(afterDocument: lastDocument)
                .getDocumentsWithSnapshotT(as: Product.self)
        } else {
            return try await productCollection
                .order(by: Product.CodingKeys.rating.rawValue, descending: true)
                .limit(to: count)
                .getDocumentsWithSnapshotT(as: Product.self)
        }
    }
    
    //MARK: - Aggregations
    func getAllProductsCount() async throws -> Int {
        try await productCollection.aggregateCount()
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
