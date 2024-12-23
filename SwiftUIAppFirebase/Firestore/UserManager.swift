//
//  UserManager.swift
//  SwiftUIAppFirebase
//
//  Created by Hakob Ghlijyan on 12/22/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore

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
    
    init(
        userID: String,
        isAnonymous: Bool? = nil,
        email: String? = nil,
        photoURL: String? = nil,
        dateCreated: Date? = nil,
        isPremium: Bool? = nil,
        preferences: [String]? = nil,
        favoritesMovie: Movie? = nil
    ) {
        self.userID = userID
        self.isAnonymous = isAnonymous
        self.email = email
        self.photoURL = photoURL
        self.dateCreated = dateCreated
        self.isPremium = isPremium
        self.preferences = preferences
        self.favoritesMovie = favoritesMovie
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
    }
}

final class UserManager {
    static let shared = UserManager()
    private init() {}
    private let userCollection = Firestore.firestore().collection("SwiftUIAppFirebase_Users")
    private func userDocument(userID: String) -> DocumentReference {
        userCollection.document(userID)
    }
    
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
}
