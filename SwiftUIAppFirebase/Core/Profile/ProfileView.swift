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
    
    //MENYAET VSE DANIE , MODET BIT CHO V Base danie kotorie poluchili pri smene , drugie toje izmenili , a mi to je izmenim na te kotorie u nas... budet ne besopasno....
//    func tooglePremiumState() {
//        guard var user else { return }
//        user.tooglePremiumState()
//        Task {
//            try await UserManager.shared.updateUserPremiumStatus(user: user)
//            self.user = try await UserManager.shared.getUser(userID: user.userID)
//        }
//    }
    // Menyaem tolko is premium po id user a
    func tooglePremiumState() {
        guard let user else { return }
        let currentUserID = user.userID
        let currentValue = user.isPremium ?? false
        Task {
            try await UserManager.shared.updateUserPremiumStatus(userID: currentUserID, isPremium: !currentValue)
            self.user = try await UserManager.shared.getUser(userID: user.userID)
        }
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
                
                Button {
                    viewModel.tooglePremiumState()
                } label: {
                    Text("User is premium: \((user.isPremium ?? false).description.capitalized)")
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
