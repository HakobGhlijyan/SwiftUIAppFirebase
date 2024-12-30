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
    
    // GET All Product
    func getAllProducts() async throws -> [Product] {
        //code ex extenson func
        try await productCollection.getDocumentsT(as: Product.self)
        //CODE
        /*
         //1: - Get all doc by product collection (is 30)
         let snapshot = try await productCollection.getDocuments()
         //1.1: Array for product for append by decodede 1 by 1 product
         var products: [Product] = []
         //2: - for in array
         for document in snapshot.documents {
             //3: decode -> my decodable data is product
             let product = try document.data(as: Product.self)
             products.append(product)
         }
         //4: - return product array
         return products
         */
    }
    
    // GET 1 Product
    func getProduct(productID: String) async throws -> Product {
        try await productDocument(productID: productID).getDocument(as: Product.self)
    }
    
    //ONLY FIRST TIME
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
    // EXAMPLE + MAP -> .......
    /*
     
     //3 UNIVERSAL - T
     func getDocumentsCustom<T>(as type: T.Type) async throws -> [T] where T: Decodable {
         let snapshot = try await self.getDocuments()
         var products: [T] = []
         for document in snapshot.documents {
             let product = try document.data(as: T.self)
             products.append(product)
         }
         return products
     }
     
     //2 S NAZNACHENIYEM TYPE.. TOLKO Product , NO UNIVERSAL
     func getDocumentsCustom(as type: Product.Type) async throws -> [Product] {
         let snapshot = try await self.getDocuments()
         var products: [Product] = []
         for document in snapshot.documents {
             let product = try document.data(as: Product.self)
             products.append(product)
         }
         return products
     }
     
     //1 BEZ NAZNACHENIYA TYPE..
     func getDocumentsCustom() async throws -> [Product] {
         let snapshot = try await self.getDocuments()
         var products: [Product] = []
         for document in snapshot.documents {
             let product = try document.data(as: Product.self)
             products.append(product)
         }
         return products
     }
     
     let cast = ["Vivien", "Marlon", "Kim", "Karl"]                         //ETO MASIV

     let lowercaseNames = cast.map { $0.lowercased() }                      //DELAEM MAP .... KAJDIY ELEMENT S MALENKOY BUKVI
     // 'lowercaseNames' == ["vivien", "marlon", "kim", "karl"]]            //!!!!POLUCHAEM!!!!

     let letterCounts = cast.map { $0.count }                               //DELAEM MAP .... KAJDIY ELEMENT S shitaya bukvi...
     // 'letterCounts' == [6, 6, 3, 4]                                      //!!!!POLUCHAEM!!!!
     */
}

