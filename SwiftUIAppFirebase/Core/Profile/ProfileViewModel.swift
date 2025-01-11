//
//  ProfileViewModel.swift
//  SwiftUIAppFirebase
//
//  Created by Hakob Ghlijyan on 1/11/25.
//

import SwiftUI
import PhotosUI

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
    
    //1,2
//    func saveProfilePhoto(item: PhotosPickerItem) {
//        Task {
//            guard let data = try await item.loadTransferable(type: Data.self) else { return }
//            
//            let (path, name) = try await StorageManager.shared.saveImage(data: data)
//            print("Success")
//            print("path: \(path)")
//            print("name: \(name)")
//        }
//    }
    
    //3//TAK MI SOXRONYALI 16288BF1-02D9-43E6-9A1F-B8138DCE6B2D.jpg, NO U NAS MOKET BIT I TAK CHTO PAPKI NET ... KAK IMET VES PTH
//    func saveProfilePhoto(item: PhotosPickerItem) {
//        guard let user else { return }
//        Task {
//            guard let data = try await item.loadTransferable(type: Data.self) else { return }
//            
//            let (path, name) = try await StorageManager.shared.saveImage(data: data, userID: user.userID)
//            print("Success")
//            print("path: \(path)")
//            print("name: \(name)")
//            
//            try await UserManager.shared.updateUserProfileImagePath(userID: user.userID, path: name)  /// NAME !!!!!!
//            //try await UserManager.shared.updateUserProfileImagePath(userID: user.userID, path: name)  /// NAME !!!!!!!
//            /*
//             Success
//             path: SwiftUIAppFirebase_Storage_Users/8cW3UudAD8MZAa075p9qHZffPja2/16288BF1-02D9-43E6-9A1F-B8138DCE6B2D.jpg  !!!!
//             name: 16288BF1-02D9-43E6-9A1F-B8138DCE6B2D.jpg
//             */
//        }
//    }
    
    //4 -> tak mi soxronim ves path
    func saveProfilePhoto(item: PhotosPickerItem) {
        guard let user else { return }
        Task {
            guard let data = try await item.loadTransferable(type: Data.self) else { return }
            
            let (path, name) = try await StorageManager.shared.saveImage(data: data, userID: user.userID)
            print("Success")
            print("path: \(path)")
            print("name: \(name)")
            
            // url for save in iser data
            let url = try await StorageManager.shared.getURLForImage(path: path)
            
            // TAk mo uje sozronili ne silku na iame  , ne path , a sam url polniy chtom brat ego 
            //try await UserManager.shared.updateUserProfileImagePath(userID: user.userID, path: url.absoluteString)
            
            // Teper dobaviv url puth mi path sdelaem path , a v url budet url...
            // path nujen budet teper dlya delete
            try await UserManager.shared.updateUserProfileImagePath(userID: user.userID, path: path, url: url.absoluteString)

        }
    }
    
    //DELETE IMAGE
    func deleteProfilePhoto() {
        guard let user , let path = user.profileImagePath else { return }
        Task {
            try await StorageManager.shared.deleteImage(path: path)
            // mi m vesto ubnovleniya , obnovlyaem na znachenie nil
            try await UserManager.shared.updateUserProfileImagePath(userID: user.userID, path: nil, url: nil)
        }
    }

}
