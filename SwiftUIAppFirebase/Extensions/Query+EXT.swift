//
//  Query+EXT.swift
//  SwiftUIAppFirebase
//
//  Created by Hakob Ghlijyan on 1/10/25.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import Combine

extension Query {
    //MARK: -  UNIVERSAL FUNC FOR IN -> ALL TYPE DECODABLE AND GET SAPSHOT -> DECODE MAP IN DOCUEMTS ARRAY FOR RETURN
    func getDocumentsT<T>(as type: T.Type) async throws -> [T] where T: Decodable {
        try await getDocumentsWithSnapshotT(as: type).product
    }
    
    //MARK: -  UNIVERSAL FUNC FOR IN -> ALL TYPE DECODABLE AND GET SAPSHOT -> DECODE MAP IN DOCUEMTS ARRAY FOR RETURN
    func getDocumentsWithSnapshotT<T>(as type: T.Type) async throws -> (product: [T], lastDocument: DocumentSnapshot?) where T: Decodable {
        let snapshot = try await self.getDocuments()
        
        let products = try snapshot.documents.map { document in
            try document.data(as: T.self)
        }
        return (products, snapshot.documents.last)
    }
    
    func startOptionally(afterDocument lastDocument: DocumentSnapshot?) -> Query {
        guard let lastDocument else { return self }
        return self.start(afterDocument: lastDocument)
    }
    
    func aggregateCount() async throws -> Int {
        let snapshot = try await self.count.getAggregation(source: .server)
        return  Int(truncating: snapshot.count)
    }
    
    //MARK: -  UNIVERSAL FUNC LISTENER COMBINE
    /*
     func addSnapshotListener(userID: String) -> (AnyPublisher<[UserFavoriteProduct], Error> , ListenerRegistration) {
         //PUBLISHER
         let publisher = PassthroughSubject<[UserFavoriteProduct], Error>()
         
         //LISTENER
         let listener = self.addSnapshotListener { querySnapshot, error in
             guard let documents = querySnapshot?.documents else {
                 print("No Document")
                 return
             }
             let products: [UserFavoriteProduct] = documents.compactMap { try? $0.data(as: UserFavoriteProduct.self) }

             publisher.send(products)
         }
         
         return (publisher.eraseToAnyPublisher(), listener)
     }
     eto func kotoraya imeet v sebe id-> a vozrochaet publisher(combine) i listener(firebase) ...
     no on ne universal
     */
    func addSnapshotListenerT<T>(as type: T.Type) -> (AnyPublisher<[T], Error> , ListenerRegistration) where T: Decodable {
        //PUBLISHER
        let publisher = PassthroughSubject<[T], Error>()
        
        //LISTENER
        let listener = self.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("No Document")
                return
            }
            let products: [T] = documents.compactMap { try? $0.data(as: T.self) }

            publisher.send(products)
        }
        
        return (publisher.eraseToAnyPublisher(), listener)
    }
}
