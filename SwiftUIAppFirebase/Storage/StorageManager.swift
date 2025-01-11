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
    
    //1
//    func saveImage(data: Data) async throws -> (path: String, name: String) {
//        let meta = StorageMetadata()
//        meta.contentType = "image/jpeg"
//        
//        let path = "\(UUID().uuidString).jpg"
//        
//        let returnedMetaData = try await storage.child(path).putDataAsync(data, metadata: meta)
//                                        
//        guard let returnedPath = returnedMetaData.path, let returnedName = returnedMetaData.name else {
//            throw URLError(.badServerResponse)
//        }
//        return (returnedPath, returnedName)
//    }
    //2
//    func saveImage(data: Data) async throws -> (path: String, name: String) {
//        let meta = StorageMetadata()
//        meta.contentType = "image/jpeg"
//        
//        let path = "\(UUID().uuidString).jpg"
//        
//        let returnedMetaData = try await imageReference.child(path).putDataAsync(data, metadata: meta)
//                                        
//        guard let returnedPath = returnedMetaData.path, let returnedName = returnedMetaData.name else {
//            throw URLError(.badServerResponse)
//        }
//        return (returnedPath, returnedName)
//    }
    //3
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
    //3.1 If uiimage save
    func saveImage(image: UIImage, userID: String) async throws -> (path: String, name: String) {
        //JPG
        guard let data = image.jpegData(compressionQuality: 1) else {
            throw URLError(.badServerResponse)
        }
        //PNG , transparants image
//        guard let data = image.pngData() else {
//            throw URLError(.badServerResponse)
//        }
        return try await saveImage(data: data, userID: userID)
    }
    /*
     //1.1 IZ DATA V UIIMAGE
     func getData(userID: String, path: String) async throws -> Data {
         // user ref... po id... potom ego path
         try await userReference(userID: userID).child(path).data(maxSize: 5 * 1024 * 1024)
         
 //        try await userReference(userID: userID)           -> SwiftUIAppFirebase_Storage_Users/8cW3UudAD8MZAa075p9qHZffPja2/
 //        .child(path).data(maxSize: 5 * 1024 * 1024)       -> 16288BF1-02D9-43E6-9A1F-B8138DCE6B2D.jpg
         
         /*
          Storage.storage().reference()
          userReference - > storage.child("SwiftUIAppFirebase_Storage_Users").child(userID)
          
          on ujr vocjol v storage= potom v papku ... i po user id , on doljem a etot -> path name: 16288BF1-02D9-43E6-9A1F-B8138DCE6B2D.jpg , ego vzayt
          userReference(userID: userID).child(!!!path).data(maxSize: 3 * 1024 * 1024)
          
          Success
          !!!!ne on  path: SwiftUIAppFirebase_Storage_Users/8cW3UudAD8MZAa075p9qHZffPja2/16288BF1-02D9-43E6-9A1F-B8138DCE6B2D.jpg
          a etot -> path name: 16288BF1-02D9-43E6-9A1F-B8138DCE6B2D.jpg
          */
     }
     //1.2srazu UIIMAGE
     func getImage(userID: String, path: String) async throws -> UIImage {
         let data = try await getData(userID: userID, path: path)
         guard let image = UIImage(data: data) else {
             throw URLError(.badServerResponse)
         }
         return image
     }
     */
 
    //2.1 IZ DATA V UIIMAGE
    func getData(userID: String, path: String) async throws -> Data {
        try await storage.child(path).data(maxSize: 5 * 1024 * 1024) //!!!!!!!!!!!!!!!
    }
    //2.2srazu UIIMAGE
    func getImage(userID: String, path: String) async throws -> UIImage {
        let data = try await getData(userID: userID, path: path)
        guard let image = UIImage(data: data) else {
            throw URLError(.badServerResponse)
        }
        return image
    }
    
    //ASYNC IMAGE DOWNLOAD
    func getURLForImage(path: String) async throws -> URL {
//        let ref = try await Storage.storage().reference(withPath: path).downloadURL()
//        return ref
        
//        return try await Storage.storage().reference(withPath: path).downloadURL()
        return try await getPathForImage(path: path).downloadURL()
    }
    
    func deleteImage(path: String) async throws {
        try await getPathForImage(path: path).delete()
    }
}
