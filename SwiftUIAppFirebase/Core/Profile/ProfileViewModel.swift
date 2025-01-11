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

    func saveProfilePhoto(item: PhotosPickerItem) {
        guard let user else { return }
        Task {
            guard let data = try await item.loadTransferable(type: Data.self) else { return }
            
            let (path, name) = try await StorageManager.shared.saveImage(data: data, userID: user.userID)
            print("Success")
            print("path: \(path)")
            print("name: \(name)")
            
            let url = try await StorageManager.shared.getURLForImage(path: path)
            try await UserManager.shared.updateUserProfileImagePath(userID: user.userID, path: path, url: url.absoluteString)

        }
    }
    
    func deleteProfilePhoto() {
        guard let user , let path = user.profileImagePath else { return }
        Task {
            try await StorageManager.shared.deleteImage(path: path)
            try await UserManager.shared.updateUserProfileImagePath(userID: user.userID, path: nil, url: nil)
        }
    }

}
