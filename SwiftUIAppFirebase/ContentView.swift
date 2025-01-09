//
//  ContentView.swift
//  SwiftUIAppFirebase
//
//  Created by Hakob Ghlijyan on 12/20/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Module 01 - Connecting to App Firebase")
            
            Text("Module 02 - Email")
            
            Text("Module 03 - Google ")
            
            Text("Module 04 - Apple")
            
            Text("Module 05 - Anon")
            
            Text("Module 06 - Delete User")
            
            Text("Module 07 - Firebase Firestore - part 1")
            
            Text("Module 07 - Firebase Firestore - part 2")
            
            Text("""
                Module 07 - Firebase Firestore - part 3
                
                End part 3
                1: -add new value in dbuser , and in model movie
                2:- preference array string
                add FieldValue.arrayUnion([preference])
                remove FieldValue.arrayRemove([preference])
                3: - add favorite movie for map datause encoder firebase for make json [String: Any] and for delete

                Profile view add func add and remove
                
                """)
            
            Text("""
                Module 07 - Firebase Firestore - part 4
                
                Part 04 End
                1.
                Add database api call
                add cell product
                ADD PRODUCT view and add iin rootview for testing
                2.
                In Product manager
                add 1 product get by id
                change get all product for custom universal func  getDocumentsT() is
                use history and map all snapshot array
                """)
            
            
            Text("""
                Module 07 - Firebase Firestore - part 5
                           
                Part 05 End
                1. add filter and category option
                filter enum
                sort category enum

                2. add button for order and fileter

                3. Add codding kay for product .. is use in func for sort

                4. Add product manager func for
                get all product .
                get one product
                get all sorted by price
                get all filter category

                add all in one func get all documents 2 func is paramets in use switch for options

                
                """)
            
            Text("""
                Module 07 - Firebase Firestore - part 6
                
                Firebase Firestore Pagination, Limits and Aggregations  
                
                Part 06 End
                1. ADD in Product model Equatable
                for _ lhs: Product, _ rhs: Product
                
                2. Add PruductViewCell rating ... for use func rating
                
                3. change all get product func 
                NOW its return is QUERY Not PRODUCT....
                USE getAllProducts(priceDescending descending: Bool?, forCategory category: String?, count: Int, lastDocument: DocumentSnapshot?) async throws -> (product: [Product], lastDocument: DocumentSnapshot?) 
                
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
                         
                
                4. Add //PRODUCT BY RATING
                    func getProductsByRating(count: Int, lastDocument: DocumentSnapshot?) async throws -> (product: [Product], lastDocument: DocumentSnapshot?)
                
                it use LIMIT
                                limit(to: count)
                
                5.
                in getAllProducts .. 
                USE LIMIT + PAGINATION 
                                count: Int, lastDocument: DocumentSnapshot?
                
                count v func in viewModel 
                
                6. 
                Extension QUERY 
                //ONLY ELEMENT..
                    func getDocumentsT<T>(as type: T.Type) async throws -> [T] where T: Decodable {
                        try await getDocumentsWithSnapshotT(as: type).product
                    }
                // ADD ELSE snapsHOT LAST ELEMET FOR PAGINATON
                    func getDocumentsWithSnapshotT<T>(as type: T.Type) async throws -> (product: [T], lastDocument: DocumentSnapshot?) where T: Decodable {
                        let snapshot = try await self.getDocuments()
                        
                        let products = try snapshot.documents.map { document in
                            try document.data(as: T.self)
                        }
                        return (products, snapshot.documents.last)
                    }
                
                7. VIEW MODEL ADD sort by rating func 
                add getproduct func 
                
                add last   private var lastDocument: DocumentSnapshot? = nil
                for savelast for pagination

                """)
            
            
            Text("""
                Module 07 - Firebase Firestore - part 7
                
                End part 7
                ADD Tab 
                1. ADD tab bar , 3 irem 
                second item is favorite
                
                2. in viewmodel add get func
                and in user manager add model for fovorite product
                
                3.
                in Product view add func for add favorite
                and remove 
                
                use func in USERmanager
                
                4. ADD CELL BUILDER
                
                5.ADD Tan BAr View
                and change in root view -> Tan BAr View
                
                6. in USer manager add user favorite collection and doc link
                
                7.for favorite 
                add func , remove
                get all favorite
                """)
            
        }
    }
}
