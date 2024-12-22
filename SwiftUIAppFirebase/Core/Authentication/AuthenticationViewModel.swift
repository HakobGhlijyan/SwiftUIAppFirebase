//
//  AuthenticationViewModel.swift
//  SwiftUIAppFirebase
//
//  Created by Hakob Ghlijyan on 12/22/24.
//

import SwiftUI

@MainActor
final class AuthenticationViewModel: ObservableObject  {
    func signInGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.singIn()
        //Create
        let authDataResult = try await AuthenticationManager.shared.singInWithGoogle(tokens: tokens)
        // Add in firestore
        try await UserManager.shared.createNewUser(auth: authDataResult)

    }
    func signInApple() async throws {
        let helper = SignInAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        //Create
        let authDataResult = try await AuthenticationManager.shared.signInWithApple(tokens: tokens)
        // Add in firestore
        try await UserManager.shared.createNewUser(auth: authDataResult)

    }
    func signInAnonymous() async throws {
        //Create
        let authDataResult = try await AuthenticationManager.shared.signInAnonymously()
        // Add in firestore
        try await UserManager.shared.createNewUser(auth: authDataResult)
    }
}
