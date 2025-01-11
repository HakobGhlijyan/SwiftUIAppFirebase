//
//  StorageManager.swift
//  SwiftUIAppFirebase
//
//  Created by Hakob Ghlijyan on 1/11/25.
//

import SwiftUI
import FirebaseStorage
import UIKit

final class StorageManager {
    static let shared = StorageManager()
    private init() {}
    
    private let storage = Storage.storage().reference()
    private var imageReference: StorageReference {
        storage.child("SwiftUIAppFirebase_Profile_Images")
    }
    private func userReference(userID: String) -> StorageReference {
        storage.child("SwiftUIAppFirebase_Storage_Users").child(userID)
    }
    private func getPathForImage(path: String) -> StorageReference {
        Storage.storage().reference(withPath: path)
    }
    
    func saveImage(data: Data, userID: String) async throws -> (path: String, name: String) {
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        
        let path = "\(UUID().uuidString).jpg"
        
        let returnedMetaData = try await userReference(userID: userID).child(path).putDataAsync(data, metadata: meta)
                                        
        guard let returnedPath = returnedMetaData.name, let returnedName = returnedMetaData.name else {
            throw URLError(.badServerResponse)
        }
        return (returnedPath, returnedName)
    }

    func saveImage(image: UIImage, userID: String) async throws -> (path: String, name: String) {
        guard let data = image.jpegData(compressionQuality: 1) else {
            throw URLError(.badServerResponse)
        }
//        guard let data = image.pngData() else {
//            throw URLError(.badServerResponse)
//        }
        return try await saveImage(data: data, userID: userID)
    }
 
    func getData(userID: String, path: String) async throws -> Data {
        try await storage.child(path).data(maxSize: 5 * 1024 * 1024)
    }
    func getImage(userID: String, path: String) async throws -> UIImage {
        let data = try await getData(userID: userID, path: path)
        guard let image = UIImage(data: data) else {
            throw URLError(.badServerResponse)
        }
        return image
    }
    
    func getURLForImage(path: String) async throws -> URL {
        return try await getPathForImage(path: path).downloadURL()
    }
    
    func deleteImage(path: String) async throws {
        try await getPathForImage(path: path).delete()
    }
}
