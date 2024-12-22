//
//  SignInEmailViewModel.swift
//  SwiftUIAppFirebase
//
//  Created by Hakob Ghlijyan on 12/22/24.
//

import SwiftUI

@MainActor
final class SignInEmailViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else { return }
        //Create
        let authDataResult = try await AuthenticationManager.shared.createUser(email: email, password: password)
        // Add in firestore
        try await UserManager.shared.createNewUser(auth: authDataResult)
    }
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else { return }
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
    }
    
}

