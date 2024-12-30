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
    
    private let productCollection = Firestore.firestore().collection("SwiftUIAppFirebase_Products")
    
    private func productDocument(productID: String) -> DocumentReference {
        productCollection.document(productID)
    }
    
    func uploadProduct(product: Product) async throws {
        try productDocument(productID: String(product.id)).setData(from: product, merge: false)
    }
    
    func getAllProducts() async throws -> [Product] {
        try await productCollection.getDocumentsT(as: Product.self)
    }
    
    func getProduct(productID: String) async throws -> Product {
        try await productDocument(productID: productID).getDocument(as: Product.self)
    }
    
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

extension Query {
    func getDocumentsT<T>(as type: T.Type) async throws -> [T] where T: Decodable {
        let snapshot = try await self.getDocuments()
        return try snapshot.documents.map { document in
            try document.data(as: T.self)
        }
    }
}

