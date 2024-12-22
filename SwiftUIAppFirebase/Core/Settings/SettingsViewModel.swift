//
//  SettingsViewModel.swift
//  SwiftUIAppFirebase
//
//  Created by Hakob Ghlijyan on 12/22/24.
//

import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var authProvider: [AuthProviderOption] = []
    @Published var authUser: AuthDataResultModel? = nil
    
    //MARK: - loadAuth
    func loadAuthProvider() {
        if let providers = try? AuthenticationManager.shared.getProviders() {
            authProvider = providers
        }
    }
    
    func loadAuthUser() {
        self.authUser = try?  AuthenticationManager.shared.getAuthenticatedUser()
    }
    
    //MARK: - SIGN OUT
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    //MARK: - Delete
    func deleteAccount() async throws {
        try await AuthenticationManager.shared.delete()
    }
    
    //MARK: - RESET
    func resetPassword() async throws {
        let autUser = try AuthenticationManager.shared.getAuthenticatedUser()
        guard let email = autUser.email else { return }
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    //MARK: - UPDATE
    func updateEmail() async throws {
        let e = "h-\(Int.random(in: 0...100))@h.com"
        try await AuthenticationManager.shared.updateEmail(email: e)
    }
    
    func updatePasword() async throws {
        let p = "Aa\(Int.random(in: 1034...1940))"
        try await AuthenticationManager.shared.updatePassword(password: p)
    }
    
    //MARK: - LINK
    func linkGoogleAccount() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.singIn()
        self.authUser = try await AuthenticationManager.shared.linkGoogle(tokens: tokens)
    }
    
    func linkAppleAccount() async throws {
        let helper = SignInAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        self.authUser = try await AuthenticationManager.shared.linkApple(tokens: tokens)
    }
    
    func linkEmailAccount() async throws {
        let e = "h-\(Int.random(in: 0...100))@h.com"
        let p = "Aa\(Int.random(in: 1034...1940))"
        
        self.authUser = try await AuthenticationManager.shared.linkEmail(email: e, password: p)
    }
}
