//
//  ProfileView.swift
//  SwiftUIAppFirebase
//
//  Created by Hakob Ghlijyan on 12/22/24.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @StateObject private var viewModel: ProfileViewModel = ProfileViewModel()
    @Binding var showSignInView: Bool
    
    @State private var selectedItem: PhotosPickerItem? = nil
    
    @State private var imageData: Data? = nil
    @State private var image: UIImage? = nil
    @State private var url: URL? = nil
    
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

                PhotosPicker(
                    selection: $selectedItem,
                    matching: .images,
                    photoLibrary: .shared()) {
                        Text("Selected a photo")
                    }

                if let urlString = viewModel.user?.profileImagePathURL, let url = URL(string: urlString) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .cornerRadius(10)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 150, height: 150)
                    }
                }
                
                if viewModel.user?.profileImagePath != nil {
                    Button("Delete Image") {
                        viewModel.deleteProfilePhoto()
                    }
                }
            }
        }
        .navigationTitle("Profile")
        .onChange(of: selectedItem, { oldValue, newValue in
            if let newValue {
                viewModel.saveProfilePhoto(item: newValue)
            }
        })
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
    ProfileView(showSignInView: .constant(false))
}
