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
    
    @State private var imageData: Data? = nil   //1
    @State private var image: UIImage? = nil    //2
    @State private var url: URL? = nil          //3
    
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

                //Photo
                PhotosPicker(
                    selection: $selectedItem,
                    matching: .images,
                    photoLibrary: .shared()) {
                        Text("Selected a photo")
                    }
                //1 iz data v UIIMAGE
//                if let imageData , let image = UIImage(data: imageData) {
//                    Image(uiImage: image)
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: 150, height: 150)
//                        .cornerRadius(10)
//                }
                //2 srazu UIIMAGE 
//                if let image {
//                    Image(uiImage: image)
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: 150, height: 150)
//                        .cornerRadius(10)
//                }
                
                //1ASYNC IMAGE URL . eto kogda mi poluchali iz path url i poluchaniy url stavili
//                if let url {
//                    AsyncImage(url: url) { image in
//                        image
//                            .resizable()
//                            .scaledToFill()
//                            .frame(width: 150, height: 150)
//                            .cornerRadius(10)
//                    } placeholder: {
//                        ProgressView()
//                            .frame(width: 150, height: 150)
//                    }
//
//                }
                
                //2ASYNC IMAGE URL uje v user profile image budet sam url
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
                
                //Button chtob udalit iamge po path v storage ,
                // proverim esli tam est iamge , tolko togda mojem udalit
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
            
            /*
             if let user = viewModel.user, let path = user.profileImagePath {
                 //1iz data v UIIMAGE
 //                let data = try? await StorageManager.shared.getData(userID: user.userID, path: path)
                 
                 //2srazu UIIMAGE
 //                let data = try? await StorageManager.shared.getImage(userID: user.userID, path: path)

                 //try await userReference(userID: userID)           -> SwiftUIAppFirebase_Storage_Users/8cW3UudAD8MZAa075p9qHZffPja2/
                 //        .child(path).data(maxSize: 5 * 1024 * 1024)       -> 16288BF1-02D9-43E6-9A1F-B8138DCE6B2D.jpg
                 
                 // path -> to -> 16288BF1-02D9-43E6-9A1F-B8138DCE6B2D.jpg
                 
                 //3 a sdes mi poluchim url
                 let url = try? await StorageManager.shared.getURLForImage(path: path)

                 
                 //1iz data v UIIMAGE
 //                self.imageData = data
                 //2srazu UIIMAGE
 //                self.image = data
                 //3FOR URL
                 self.url = url
             }
             */
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
