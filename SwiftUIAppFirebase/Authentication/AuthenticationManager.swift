//
//  AuthenticationManager.swift
//  SwiftUIAppFirebase
//
//  Created by Hakob Ghlijyan on 12/20/24.
//

import SwiftUI
import FirebaseAuth

struct AuthDataResultModel {
    let uid: String
    let email: String?
    let photoURL: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoURL = user.photoURL?.absoluteString
    }
}

final class AuthenticationManager {
    static let shared = AuthenticationManager()
    private init() { }
    
    // This Local -> only throw -> error -> sync func
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badURL)
        }
        return AuthDataResultModel(user: user)
    }
    
    // This server -> async throw -> error -> async func
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    // This Local -> only throw -> error -> sync func
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
}
