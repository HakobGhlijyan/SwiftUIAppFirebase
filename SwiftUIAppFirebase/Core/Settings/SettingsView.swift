//
//  SettingsView.swift
//  SwiftUIAppFirebase
//
//  Created by Hakob Ghlijyan on 12/20/24.
//

import SwiftUI

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
            
            Button("Delete Account", role: .destructive) {
                Task {
                    do {
                        try await viewModel.deleteAccount()
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


//  SwiftUI_App_Firebase_Users
//  SwiftUI_App_Firebase_Grocery_List
//  SwiftUI_App_Firebase_Fruits
