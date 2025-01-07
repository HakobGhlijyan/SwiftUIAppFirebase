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
    
    //1 Version
    /*
     
     //MARK: - GET ALL ARRAY PRODUCT
     //0. - ALL PRODUCT
     private func getAllProducts() async throws -> [Product] {
         try await productCollection
 //            .limit(to: 5) // limit for collection first 5 elements
             .getDocumentsT(as: Product.self)
     }
     //2. - PRODUCT BY SORT
     private func getAllProductsSortedByPrice(descending: Bool) async throws -> [Product] {
         try await productCollection
             .order(by: Product.CodingKeys.price.rawValue, descending: descending)
 //            .limit(to: 3) //price is first product ex(1 2 3)
 //            .limit(toLast: 3) //priceis last product ex( 28 29 30 )
             .getDocumentsT(as: Product.self)
     }
     //3. - PRODUCT BY FILTER
     private func getAllProductsForCategory(category: String) async throws -> [Product] {
         try await productCollection
             .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
             .getDocumentsT(as: Product.self)
     }
     
     //1. - PRODUCT BY SORT AND FILTER
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
     
     */
    
    //2 Version
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
        
        /*
         TEPER ISPOLZUEM EGO
         func startOptionally(afterDocument lastDocument: DocumentSnapshot?) -> Query {
             guard let lastDocument else { return self }
             return self.start(afterDocument: lastDocument)
         }
         
         A POTOM EGO
         
         .getDocumentsWithSnapshotT(as: Product.self)

         VMSTO ETOGO
         
         
         if let lastDocument {
             return try await query
                 .limit(to: count)
                 .start(afterDocument: lastDocument)
                 .getDocumentsWithSnapshotT(as: Product.self)
         } else {
             return try await query
                 .limit(to: count)
                 .getDocumentsWithSnapshotT(as: Product.self)
         }
         
         
         */
        
    }
    
    //3 - IN COUNT , IN LAST
//    func getAllProducts(priceDescending descending: Bool?, forCategory category: String?, count: Int, lastDocument: DocumentSnapshot?) async throws -> (product: [Product], lastDocument: DocumentSnapshot?) {
//        var query: Query = getAllProductsQuery()
//        
//        if let descending, let category {
//            query = getAllProductsByPriceAndCategoryQuery(descending: descending, category: category)
//        } else if let descending {
//            query = getAllProductsSortedByPriceQuery(descending: descending)
//        } else if let category {
//            query = getAllProductsForCategoryQuery(category: category)
//        }
//         
//        if let lastDocument {
//            return try await query
//                .limit(to: count)
//                .start(afterDocument: lastDocument)
//                .getDocumentsWithSnapshotT(as: Product.self)
//        } else {
//            return try await query
//                .limit(to: count)
//                .getDocumentsWithSnapshotT(as: Product.self)
//        }
//    }
    
    
    //2 - COUNT , NO LAST
//    func getAllProducts(priceDescending descending: Bool?, forCategory category: String?, count: Int) async throws -> [Product] {
//        var query: Query = getAllProductsQuery()
//        
//        if let descending, let category {
//            query = getAllProductsByPriceAndCategoryQuery(descending: descending, category: category)
//        } else if let descending {
//            query = getAllProductsSortedByPriceQuery(descending: descending)
//        } else if let category {
//            query = getAllProductsForCategoryQuery(category: category)
//        }
//         
//        return try await query
//            .limit(to: count)
//            .getDocumentsT(as: Product.self)
//    }
    
    // 1- NO COUNT
//    func getAllProducts(priceDescending descending: Bool?, forCategory category: String?) async throws -> [Product] {
//        var query: Query = getAllProductsQuery()
//        
//        if let descending, let category {
//            query = getAllProductsByPriceAndCategoryQuery(descending: descending, category: category)
//        } else if let descending {
//            query = getAllProductsSortedByPriceQuery(descending: descending)
//        } else if let category {
//            query = getAllProductsForCategoryQuery(category: category)
//        }
//        
//        return try await query.getDocumentsT(as: Product.self)
//    }


    //MARK: - PRODUCT BY RATING
    //PRODUCT BY RATING
//    func getProductsByRating(count: Int, lastRating: Double?) async throws -> [Product] {
//        try await productCollection
//            .order(by: Product.CodingKeys.rating.rawValue, descending: true)
//            .limit(to: count)
//            .start(at: [4.5])
//            .start(after: [lastRating ?? 9999999])
//            .getDocumentsT(as: Product.self)
//    }
    
    //PRODUCT BY RATING
    func getProductsByRating(count: Int, lastDocument: DocumentSnapshot?) async throws -> (product: [Product], lastDocument: DocumentSnapshot?) {
//        DocumentSnapshot? on optional , i chtob roverit ego na nil
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
//        let snapshot = try await productCollection
//            .count                                      // POSCHITAT SKOLKO ELEMETS V COLLECTION
//            .getAggregation(source: .server)            // I S POMOSHYU getAggregation KORTORIY VERNET TOLKO INT , CHISLO
//        
//        return Int(truncating: <#T##NSNumber#>)
//        return Int(truncating: snapshot.count)
        
        try await productCollection.aggregateCount()
    }
    
}

extension Query {
    //MARK: -  UNIVERSAL FUNC FOR IN -> ALL TYPE DECODABLE AND GET SAPSHOT -> DECODE MAP IN DOCUEMTS ARRAY FOR RETURN
    /// (ONLY PRODUCT ARRAY)
    /// ETA FUNC POLUCHAET I VOZROSHAET PRODUCT, BEZ LAST DOCUMENT
//    func getDocumentsT<T>(as type: T.Type) async throws -> [T] where T: Decodable {
//        let snapshot = try await self.getDocuments()
//        return try snapshot.documents.map { document in
//            try document.data(as: T.self)
//        }
//    }
    
    func getDocumentsT<T>(as type: T.Type) async throws -> [T] where T: Decodable {
        try await getDocumentsWithSnapshotT(as: type).product
    }
    
    //MARK: -  UNIVERSAL FUNC FOR IN -> ALL TYPE DECODABLE AND GET SAPSHOT -> DECODE MAP IN DOCUEMTS ARRAY FOR RETURN
    /// ( IN LAST DOCUMENTS GET )
//    func getDocumentsWithSnapshotT<T>(as type: T.Type) async throws -> (product: [T], lastDocument: DocumentSnapshot?) where T: Decodable {
//        let snapshot = try await self.getDocuments()
//        
//        let products = try snapshot.documents.map { document in
//            try document.data(as: T.self)
//        }
//        return (products, snapshot.documents.last)
//    }
    
    //MARK: -  UNIVERSAL FUNC FOR IN -> ALL TYPE DECODABLE AND GET SAPSHOT -> DECODE MAP IN DOCUEMTS ARRAY FOR RETURN
    /// ( IN LAST DOCUMENTS GET )
    func getDocumentsWithSnapshotT<T>(as type: T.Type) async throws -> (product: [T], lastDocument: DocumentSnapshot?) where T: Decodable {
        let snapshot = try await self.getDocuments()
        
        let products = try snapshot.documents.map { document in
            try document.data(as: T.self)
        }
        return (products, snapshot.documents.last)
    }
    
    func startOptionally(afterDocument lastDocument: DocumentSnapshot?) -> Query {
//        if let lastDocument {
//            return self.start(afterDocument: lastDocument)
//        } else {
//            return self
//        }
        
        guard let lastDocument else { return self }
        return self.start(afterDocument: lastDocument)
    }
    
    func aggregateCount() async throws -> Int {
        let snapshot = try await self.count.getAggregation(source: .server)
        return  Int(truncating: snapshot.count)
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
