//
//  SettingsView.swift
//  SwiftUIAppFirebase
//
//  Created by Hakob Ghlijyan on 12/20/24.
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

struct SettingsView: View {
    @StateObject private var viewModel: SettingsViewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        List {
            Button("Log Out") {
                Task {
                    do {
                        try viewModel.signOut()
                        showSignInView = true
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            
            if viewModel.authProvider.contains(.email) {
                emailSection
            }
            
            if viewModel.authUser?.isAnonymous == true {
                linkSection
            }
            
        }
        .onAppear {
            viewModel.loadAuthProvider()
            viewModel.loadAuthUser()
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationStack {
        SettingsView(showSignInView: .constant(false))
    }
}

extension SettingsView {
    private var emailSection: some View {
        Section {
            Button("Reset Password") {
                Task {
                    do {
                        try await viewModel.resetPassword()
                        print("Password reset!")
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            Button("Update Email") {
                Task {
                    do {
                        try await viewModel.updateEmail()
                        print("Update Email!")
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            Button("Update Password") {
                Task {
                    do {
                        try await viewModel.updatePasword()
                        print("Update Password!")
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        } header: {
            Text("Email Settings")
        }
    }
    
    private var linkSection: some View {
        Section {
            Button("Link Google Account") {
                Task {
                    do {
                        try await viewModel.linkGoogleAccount()
                        print("Google Linked Successfully!")
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            Button("Link Apple Account") {
                Task {
                    do {
                        try await viewModel.linkAppleAccount()
                        print("Apple Linked Successfully!")
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            Button("Link Email Account") {
                Task {
                    do {
                        try await viewModel.linkEmailAccount()
                        print("Email Linked Successfully!")
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        } header: {
            Text("Create Account")
        }
    }
}
