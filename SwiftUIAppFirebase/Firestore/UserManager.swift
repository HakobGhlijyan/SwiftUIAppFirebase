//
//  UserManager.swift
//  SwiftUIAppFirebase
//
//  Created by Hakob Ghlijyan on 12/22/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct DBUser: Codable {
    let userID: String
    let isAnonymous: Bool?
    let email: String?
    let photoURL: String?
    let dateCreated: Date?
    let isPremium: Bool?
    
    init(
        userID: String,
        isAnonymous: Bool? = nil,
        email: String? = nil,
        photoURL: String? = nil,
        dateCreated: Date? = nil,
        isPremium: Bool? = nil
    ) {
        self.userID = userID
        self.isAnonymous = isAnonymous
        self.email = email
        self.photoURL = photoURL
        self.dateCreated = dateCreated
        self.isPremium = isPremium
    }
    
    init(auth: AuthDataResultModel) {
        self.userID = auth.uid
        self.isAnonymous = auth.isAnonymous
        self.email = auth.email
        self.photoURL = auth.photoURL
        self.dateCreated = Date()
        self.isPremium = false
    }
    
    enum CodingKeys: String, CodingKey{
        case userID = "user_id"
        case isAnonymous = "is_anonymous"
        case email = "email"
        case photoURL = "photo_url"
        case dateCreated = "date_created"
        case isPremium = "is_premium"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userID = try container.decode(String.self, forKey: .userID)
        self.isAnonymous = try container.decodeIfPresent(Bool.self, forKey: .isAnonymous)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.photoURL = try container.decodeIfPresent(String.self, forKey: .photoURL)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
        self.isPremium = try container.decodeIfPresent(Bool.self, forKey: .isPremium)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userID, forKey: .userID)
        try container.encodeIfPresent(self.isAnonymous, forKey: .isAnonymous)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.photoURL, forKey: .photoURL)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
        try container.encodeIfPresent(self.isPremium, forKey: .isPremium)
    }
    
//    func tooglePremiumState() -> DBUser {
//        let currentValue = isPremium ?? false
//
//        return DBUser(
//            userID: userID,
//            isAnonymous: isAnonymous,
//            email: email,
//            photoURL: photoURL,
//            dateCreated: dateCreated,
//            isPremium: !currentValue
//        )
//    }
    
//    mutating func tooglePremiumState() {
//        let currentValue = isPremium ?? false
//        isPremium = !currentValue
//    }
}

final class UserManager {
    static let shared = UserManager()
    private init() {}
    private let userCollection = Firestore.firestore().collection("SwiftUIAppFirebase_Users")
    private func userDocument(userID: String) -> DocumentReference {
        userCollection.document(userID)
    }
//    private let encoder: Firestore.Encoder = {
//        let encoder = Firestore.Encoder()
//        encoder.keyEncodingStrategy = .convertToSnakeCase
//        return encoder
//    }()
//    private let decoder: Firestore.Decoder = {
//        let decoder = Firestore.Decoder()
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
//        return decoder
//    }()
    func createNewUser(user: DBUser) async throws {
        try userDocument(userID: user.userID).setData(from: user, merge: false)
    }
    func getUser(userID: String) async throws -> DBUser {
        try await userDocument(userID: userID).getDocument(as: DBUser.self)
    }
    //MENYAET VSE DANIE , MODET BIT CHO V Base danie kotorie poluchili pri smene , drugie toje izmenili , a mi to je izmenim na te kotorie u nas... budet ne besopasno....
//    func updateUserPremiumStatus(user: DBUser) async throws {
//        try userDocument(userID: user.userID).setData(from: user, merge: true)
//    }
    // Menyaem tolko is premium po id user a
    func updateUserPremiumStatus(userID: String, isPremium: Bool) async throws {
        let data: [String: Any] = [
//            "is_premium" : isPremium
            // V MESTO TOGO CHTOB V Ruchnuyu pisat key ->
            
            DBUser.CodingKeys.isPremium.rawValue : isPremium
        ]
        try await userDocument(userID: userID).updateData(data)
    }
}

//2
/*
 struct DBUser: Codable {
     let userID: String
     let isAnonymous: Bool?
     let email: String?
     let photoURL: String?
     let dateCreated: Date?
     let isPremium: Bool?
     
     init(
         userID: String,
         isAnonymous: Bool? = nil,
         email: String? = nil,
         photoURL: String? = nil,
         dateCreated: Date? = nil,
         isPremium: Bool? = nil
     ) {
         self.userID = userID
         self.isAnonymous = isAnonymous
         self.email = email
         self.photoURL = photoURL
         self.dateCreated = dateCreated
         self.isPremium = isPremium
     }
     
     init(auth: AuthDataResultModel) {
         self.userID = auth.uid
         self.isAnonymous = auth.isAnonymous
         self.email = auth.email
         self.photoURL = auth.photoURL
         self.dateCreated = Date()
         self.isPremium = false
     }
     
     enum CodingKeys: String, CodingKey{
         case userID = "user_id"
         case isAnonymous = "is_anonymous"
         case email = "email"
         case photoURL = "photo_url"
         case dateCreated = "date_created"
         case isPremium = "is_premium"
     }
 }

 final class UserManager {
     static let shared = UserManager()
     private init() {}
     //MARK: - USERS PATH IN FIREBASE
     private let userCollection = Firestore.firestore().collection("SwiftUIAppFirebase_Users")
     private func userDocument(userID: String) -> DocumentReference {
         userCollection.document(userID)
     }
     //MARK: - Firestore Encoder
     private let encoder: Firestore.Encoder = {
         let encoder = Firestore.Encoder()
         encoder.keyEncodingStrategy = .convertToSnakeCase
         return encoder
     }()
     //MARK: - Firestore Decoder
     private let decoder: Firestore.Decoder = {
         let decoder = Firestore.Decoder()
         decoder.keyDecodingStrategy = .convertFromSnakeCase
         return decoder
     }()
     //MARK: - 3: CREATE USER IN FIRESTORE , Add Encoder
     func createNewUser(user: DBUser) async throws {
 //        try userDocument(userID: user.userID).setData(from: user, merge: false, encoder: encoder)
 //        DONT WORK Firestore.Encoder
         try userDocument(userID: user.userID).setData(from: user, merge: false)
     }
     //MARK: - GET USER DATA IN FIRESTORE
     func getUser(userID: String) async throws -> DBUser {
 //        try await userDocument(userID: userID).getDocument(as: DBUser.self, decoder: decoder)
 //        DONT WORK Firestore.Decoder
         try await userDocument(userID: userID).getDocument(as: DBUser.self)
     }
     //MARK: - UPDATE USER DATA IN FIRESTORE
     func updateUserPremiumStatus(user: DBUser) async throws {
 //        try userDocument(userID: user.userID).setData(from: user, merge: true, encoder: encoder)
 //        DONT WORK Firestore.Encoder
         try userDocument(userID: user.userID).setData(from: user, merge: true)
     }
 }
 */

//1
/*
 final class UserManager {
     static let shared = UserManager()
     private init() {}
     
     //MARK: - USERS PATH IN FIREBASE
     private let userCollection = Firestore.firestore().collection("SwiftUIAppFirebase_Users")
     private func userDocument(userID: String) -> DocumentReference {
         userCollection.document(userID)
     }
     
     //MARK: - Firestore Encoder
     private let encoder: Firestore.Encoder = {
         let encoder = Firestore.Encoder()
         encoder.keyEncodingStrategy = .convertToSnakeCase
         return encoder
     }()
     
     //MARK: - Firestore Decoder
     private let decoder: Firestore.Decoder = {
         let decoder = Firestore.Decoder()
         decoder.keyDecodingStrategy = .convertFromSnakeCase
         return decoder
     }()
     
     //MARK: - 3: CREATE USER IN FIRESTORE , Add Encoder
     func createNewUser(user: DBUser) async throws {
         try userDocument(userID: user.userID).setData(from: user, merge: false, encoder: encoder)
     }
     
     //MARK: - 2: CREATE USER IN FIRESTORE , No Encoder and Dicionary
     /*
      //MARK: - 2: CREATE USER IN FIRESTORE , No Encoder
      func createNewUser(user: DBUser) async throws {
          try userDocument(userID: user.userID).setData(from: user, merge: false)
      }
      
      //MARK: - 1: CREATE USER IN FIRESTORE
      func createNewUser(auth: AuthDataResultModel) async throws {
          var userData: [String: Any] = [
              "user_id" : auth.uid,
              "is_anonymous" : auth.isAnonymous,
              "date_created" : Timestamp(),
          ]
          if let email = auth.email {
              userData["email"] = email
          }
          if let photoURL = auth.photoURL {
              userData["photo_url"] = photoURL
          }
          
          try await userDocument(userID: auth.uid).setData(userData, merge: false)
      }
      */
     
     //MARK: - GET USER DATA IN FIRESTORE
     func getUser(userID: String) async throws -> DBUser {
         try await userDocument(userID: userID).getDocument(as: DBUser.self, decoder: decoder)
     }
     
     //MARK: - 2: CREATE USER IN FIRESTORE , No Encoder and Dicionary
     /*
      //MARK: - GET USER DATA IN FIRESTORE - async iin call in database and if return error ( add async throw )
      func getUser(userID: String) async throws -> DBUser {
          //1 link for user doc in firestore -> //get doc in DocumentSnapshot version
          let snapshot = try await userDocument(userID: userID).getDocument()
          
          //2 data, return data in dictionary -> for created
          guard let data = snapshot.data() else {
              throw URLError(.dataNotAllowed)
          }
          
          guard let userID = data["user_id"] as? String else {
              throw URLError(.dataNotAllowed)
          }
          
          //3 data as in ->
          let isAnonymous = data["is_anonymous"] as? Bool
          let dateCreated = data["date_created"] as? Date
          let email = data["email"] as? String
          let photoURL = data["photo_url"] as? String
          
          return DBUser(userID: userID, isAnonymous: isAnonymous, email: email, photoURL: photoURL, dateCreated: dateCreated)
      }
      */
 }

 */
