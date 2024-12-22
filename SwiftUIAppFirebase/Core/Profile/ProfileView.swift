//
//  ProfileView.swift
//  SwiftUIAppFirebase
//
//  Created by Hakob Ghlijyan on 12/22/24.
//

import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published private(set) var user: DBUser? = nil
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userID: authDataResult.uid)
    }
}

struct ProfileView: View {
    @StateObject private var viewModel: ProfileViewModel = ProfileViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        List {
            if let user = viewModel.user {
                Text("UserID: \(user.userID)")
                
                if let isAnonymous = user.isAnonymous {
                    Text("Anonymous: \(isAnonymous.description.capitalized)")
                }
            }
        }
        .navigationTitle("Profile")
        .task {
            try? await viewModel.loadCurrentUser()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    SettingsView(showSignInView: $showSignInView)
                } label: {
                    Image(systemName: "gear")
                        .font(.headline)
                }

            }
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView(showSignInView: .constant(false))
    }
}
