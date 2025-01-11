//
//  UserManager.swift
//  SwiftUIAppFirebase
//
//  Created by Hakob Ghlijyan on 12/22/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import Combine

struct Movie: Codable {
    let id: String
    let title: String
    let isPopular: Bool
}

struct DBUser: Codable {
    let userID: String
    let isAnonymous: Bool?
    let email: String?
    let photoURL: String?
    let dateCreated: Date?
    let isPremium: Bool?
    let preferences: [String]?
    let favoritesMovie: Movie?
    let profileImagePath: String?
    let profileImagePathURL: String?
    
    init(
        userID: String,
        isAnonymous: Bool? = nil,
        email: String? = nil,
        photoURL: String? = nil,
        dateCreated: Date? = nil,
        isPremium: Bool? = nil,
        preferences: [String]? = nil,
        favoritesMovie: Movie? = nil,
        profileImagePath: String? = nil,
        profileImagePathURL: String? = nil
    ) {
        self.userID = userID
        self.isAnonymous = isAnonymous
        self.email = email
        self.photoURL = photoURL
        self.dateCreated = dateCreated
        self.isPremium = isPremium
        self.preferences = preferences
        self.favoritesMovie = favoritesMovie
        self.profileImagePath = profileImagePath
        self.profileImagePathURL = profileImagePathURL
    }
    
    init(auth: AuthDataResultModel) {
        self.userID = auth.uid
        self.isAnonymous = auth.isAnonymous
        self.email = auth.email
        self.photoURL = auth.photoURL
        self.dateCreated = Date()
        self.isPremium = false
        self.preferences = nil
        self.favoritesMovie = nil
        self.profileImagePath = nil
        self.profileImagePathURL = nil
    }
    
    enum CodingKeys: String, CodingKey{
        case userID = "user_id"
        case isAnonymous = "is_anonymous"
        case email = "email"
        case photoURL = "photo_url"
        case dateCreated = "date_created"
        case isPremium = "is_premium"
        case preferences = "preferences"
        case favoritesMovie = "favorites_movie"
        case profileImagePath = "profile_image_path"
        case profileImagePathURL = "profile_image_path_url"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userID = try container.decode(String.self, forKey: .userID)
        self.isAnonymous = try container.decodeIfPresent(Bool.self, forKey: .isAnonymous)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.photoURL = try container.decodeIfPresent(String.self, forKey: .photoURL)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
        self.isPremium = try container.decodeIfPresent(Bool.self, forKey: .isPremium)
        self.preferences = try container.decodeIfPresent([String].self, forKey: .preferences)
        self.favoritesMovie = try container.decodeIfPresent(Movie.self, forKey: .favoritesMovie)
        self.profileImagePath = try container.decodeIfPresent(String.self, forKey: .profileImagePath)
        self.profileImagePathURL = try container.decodeIfPresent(String.self, forKey: .profileImagePathURL)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userID, forKey: .userID)
        try container.encodeIfPresent(self.isAnonymous, forKey: .isAnonymous)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.photoURL, forKey: .photoURL)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
        try container.encodeIfPresent(self.isPremium, forKey: .isPremium)
        try container.encodeIfPresent(self.preferences, forKey: .preferences)
        try container.encodeIfPresent(self.favoritesMovie, forKey: .favoritesMovie)
        try container.encodeIfPresent(self.profileImagePath, forKey: .profileImagePath)
        try container.encodeIfPresent(self.profileImagePathURL, forKey: .profileImagePathURL)
    }
}

final class UserManager {
    static let shared = UserManager()
    private init() {}
    
    //MARK:  - USER COLLECTION -> path collection -> path document
    private let userCollection: CollectionReference = Firestore.firestore().collection("SwiftUIAppFirebase_Users")
    private func userDocument(userID: String) -> DocumentReference {
        userCollection.document(userID)
    }
    
    //MARK:  - FAVORITE COLLECTION -> path collection -> path document
    private func userFavoriteProductCollection(userID: String) -> CollectionReference {
        userDocument(userID: userID).collection("favorite_products")
    }
    private func userFavoriteProductDocument(userID: String, favoriteProductID: String) -> DocumentReference {
        userFavoriteProductCollection(userID: userID).document(favoriteProductID)
    }
 
    //MARK: - CREATE > GET > UPDATE
    func createNewUser(user: DBUser) async throws {
        try userDocument(userID: user.userID).setData(from: user, merge: false)
    }
    
    func getUser(userID: String) async throws -> DBUser {
        try await userDocument(userID: userID).getDocument(as: DBUser.self)
    }
    
    func updateUserPremiumStatus(userID: String, isPremium: Bool) async throws {
        let data: [String: Any] = [DBUser.CodingKeys.isPremium.rawValue : isPremium]
        try await userDocument(userID: userID).updateData(data)
    }
    
    func updateUserProfileImagePath(userID: String, path: String?, url: String?) async throws {
        let data: [String: Any] = [
            DBUser.CodingKeys.profileImagePath.rawValue : path,
            DBUser.CodingKeys.profileImagePathURL.rawValue : url,
        ]
        try await userDocument(userID: userID).updateData(data)
    }
    
    //MARK: - ARRAY
    func addUserPreference(userID: String, preference: String) async throws {
        let data: [String: Any] = [
            DBUser.CodingKeys.preferences.rawValue : FieldValue.arrayUnion([preference])
        ]
        try await userDocument(userID: userID).updateData(data)
    }
    
    func removeUserPreference(userID: String, preference: String) async throws {
        let data: [String: Any] = [
            DBUser.CodingKeys.preferences.rawValue : FieldValue.arrayRemove([preference])
        ]
        try await userDocument(userID: userID).updateData(data)
    }
    
    //MARK: - ARRAY MAP
    func addFavoriteMovie(userID: String, movie: Movie) async throws {
        let encoder = Firestore.Encoder()
        guard let data = try? encoder.encode(movie) else {
            throw URLError(.badURL)
        }
        let dic: [String: Any] = [
            DBUser.CodingKeys.favoritesMovie.rawValue : data
        ]
        try await userDocument(userID: userID).updateData(dic)
    }
    
    func removeFavoriteMovie(userID: String) async throws {
        let data: [String: Any?] = [
            DBUser.CodingKeys.favoritesMovie.rawValue : nil
        ]
        try await userDocument(userID: userID).updateData(data as [AnyHashable : Any])
    }
    
    //MARK: - ADD FAVORITES FOR USER
    func addUserFavoriteProduct(userID: String, productID: Int) async throws {
        let document = userFavoriteProductCollection(userID: userID).document()
        let documentID = document.documentID
        let data: [String: Any] = [
            UserFavoriteProduct.CodingKeys.id.rawValue: documentID,
            UserFavoriteProduct.CodingKeys.productID.rawValue: productID,
            UserFavoriteProduct.CodingKeys.dateCreated.rawValue: Timestamp()
        ]
        try await document.setData(data, merge: false)
    }
    
    func removeUserFavoriteProduct(userID: String, favoriteProductID: String) async throws {
        try await userFavoriteProductDocument(userID: userID, favoriteProductID: favoriteProductID).delete()
    }
        
    func getAllUserFavoriteProducts(userID: String) async throws -> [UserFavoriteProduct] {
        try await userFavoriteProductCollection(userID: userID).getDocumentsT(as: UserFavoriteProduct.self)
    }
    
    //MARK: - LISTENER - Add Combine
    func addListenerForAllUserFavoriteProductsCombine(userID: String) -> AnyPublisher<[UserFavoriteProduct], Error>  {
        let (publisher, listener) = userFavoriteProductCollection(userID: userID).addSnapshotListenerT(as: UserFavoriteProduct.self)
        
        self.userFavoriteProductListener = listener
        return publisher
    }
    
    //MARK: - LISTENER - No Combine
    func addListenerForAllUserFavoriteProducts(userID: String, completion: @escaping (_ products: [UserFavoriteProduct]) -> Void ) {
        self.userFavoriteProductListener = userFavoriteProductCollection(userID: userID).addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("No Document")
                return
            }
            let products: [UserFavoriteProduct] = documents.compactMap { try? $0.data(as: UserFavoriteProduct.self) }

            completion(products)
            
            querySnapshot?.documentChanges.forEach { diff in
                if (diff.type == .added) {
                    print("New product: \(diff.document.data())")
                }
                if (diff.type == .modified) {
                    print("Modified product: \(diff.document.data())")
                }
                if (diff.type == .removed) {
                    print("Removed product: \(diff.document.data())")
                }
            }

        }
        
    }
    private var userFavoriteProductListener: ListenerRegistration? = nil
    
    func removeListenerForAllUserFavoriteProducts() {
        self.userFavoriteProductListener?.remove()
    }
    
}

struct UserFavoriteProduct: Codable {
    let id: String
    let productID: Int
    let dateCreated: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case productID = "product_id"
        case dateCreated = "date_created"
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.productID, forKey: .productID)
        try container.encode(self.dateCreated, forKey: .dateCreated)
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.productID = try container.decode(Int.self, forKey: .productID)
        self.dateCreated = try container.decode(Date.self, forKey: .dateCreated)
    }
}
