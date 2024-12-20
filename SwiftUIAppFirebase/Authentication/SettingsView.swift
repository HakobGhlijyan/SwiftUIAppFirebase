//
//  SettingsView.swift
//  SwiftUIAppFirebase
//
//  Created by Hakob Ghlijyan on 12/20/24.
//

import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func resetPassword() async throws {
        let autUser = try AuthenticationManager.shared.getAuthenticatedUser()
        guard let email = autUser.email else { return }
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    func updateEmail() async throws {
        let e = "h@h.com"
        try await AuthenticationManager.shared.updateEmail(email: e)
    }
    
    func updatePasword() async throws {
        let p = "Aa1234567890"
        try await AuthenticationManager.shared.updatePassword(password: p)
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
            emailSection
        }
        .navigationTitle("Settings")
    }
    
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
}

#Preview {
    NavigationStack {
        SettingsView(showSignInView: .constant(false))
    }
}
