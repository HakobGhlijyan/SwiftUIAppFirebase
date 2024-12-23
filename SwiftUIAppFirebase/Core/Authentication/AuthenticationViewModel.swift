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
        let authDataResult = try await AuthenticationManager.shared.singInWithGoogle(tokens: tokens)
        let user = DBUser(auth: authDataResult)
        try await UserManager.shared.createNewUser(user: user)

    }
    func signInApple() async throws {
        let helper = SignInAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        let authDataResult = try await AuthenticationManager.shared.signInWithApple(tokens: tokens)
        let user = DBUser(auth: authDataResult)
        try await UserManager.shared.createNewUser(user: user)

    }
    func signInAnonymous() async throws {
        let authDataResult = try await AuthenticationManager.shared.signInAnonymously()
        let user = DBUser(auth: authDataResult)
        try await UserManager.shared.createNewUser(user: user)
    }
}
