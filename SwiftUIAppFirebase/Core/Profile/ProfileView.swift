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
    //MARK: - LOAD
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userID: authDataResult.uid)
    }
    //MARK: - TOOGLE Premium state   
    func tooglePremiumState() {
        guard let user else { return }
        let currentUserID = user.userID
        let currentValue = user.isPremium ?? false
        Task {
            try await UserManager.shared.updateUserPremiumStatus(userID: currentUserID, isPremium: !currentValue)
            self.user = try await UserManager.shared.getUser(userID: user.userID)
        }
    }
    //MARK: - ADD -> REMOVE Preference
    func addUserPreference(text: String) {
        guard let user else { return }
        Task {
            try await UserManager.shared.addUserPreference(userID: user.userID, preference: text)
            self.user = try await UserManager.shared.getUser(userID: user.userID)
        }
    }
    func removeUserPreference(text: String) {
        guard let user else { return }
        Task {
            try await UserManager.shared.removeUserPreference(userID: user.userID, preference: text)
            self.user = try await UserManager.shared.getUser(userID: user.userID)
        }
    }
    //MARK: - ADD -> REMOVE fovorite movie
    func addFavoriteMovie() {
        guard let user else { return }
        let movie = Movie(id: "0", title: "Avangers", isPopular: true)
        Task {
            try await UserManager.shared.addFavoriteMovie(userID: user.userID, movie: movie)
            self.user = try await UserManager.shared.getUser(userID: user.userID)
        }
    }
    func removeFavoriteMovie() {
        guard let user else { return }
        Task {
            try await UserManager.shared.removeFavoriteMovie(userID: user.userID)
            self.user = try await UserManager.shared.getUser(userID: user.userID)
        }
    }
    
}

struct ProfileView: View {
    @StateObject private var viewModel: ProfileViewModel = ProfileViewModel()
    @Binding var showSignInView: Bool
    
    let preferenceOptions: [String] = ["Sports", "Music", "Movies", "Books"]
    
    private func preferencesIsSelected(text: String) -> Bool {
        viewModel.user?.preferences?.contains(text) == true
    }
    
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
                
                VStack {
                    HStack {
                        ForEach(preferenceOptions, id: \.self) { string in
                            Button(string) {
                                if preferencesIsSelected(text: string) {
                                    viewModel.removeUserPreference(text: string)
                                } else {
                                    viewModel.addUserPreference(text: string)
                                }
                            }
                            .font(.subheadline)
                            .buttonStyle(.borderedProminent)
                            .tint(preferencesIsSelected(text: string) ? .green : .red)
                        }
                    }
                    
                    Text("User Preferences: \( (user.preferences ?? []).joined(separator: ", ") )")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.subheadline)
                }
                
                Button {
                    if user.favoritesMovie == nil {
                        viewModel.addFavoriteMovie()
                    } else {
                        viewModel.removeFavoriteMovie()
                    }
                    
                } label: {
                    Text("Favorite Movie: \( (user.favoritesMovie?.title ?? "") )")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.subheadline)
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
    RootView()
}
