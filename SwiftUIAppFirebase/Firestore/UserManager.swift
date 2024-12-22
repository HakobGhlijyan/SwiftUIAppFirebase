//
//  UserManager.swift
//  SwiftUIAppFirebase
//
//  Created by Hakob Ghlijyan on 12/22/24.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreCombineSwift
import FirebaseStorage
import FirebaseStorageCombineSwift
import FirebaseDatabase

struct DBUser {
    let userID: String
    let isAnonymous: Bool?
    let email: String?
    let photoURL: String?
    let dateCreated: Date?
}

final class UserManager {
    static let shared = UserManager()
    private init() {}
    
    //MARK: - CREATE USER IN FIRESTORE
    func createNewUser(auth: AuthDataResultModel) async throws {
        var userData: [String: Any] = [
            "user_id" : auth.uid,
            "is_anonymous" : auth.isAnonymous,
            "date_created" : Timestamp(),
        ]
        if let email = auth.email {
            userData["email"] = email
        }
        if let photoURL = auth.photoURL {
            userData["photo_url"] = photoURL
        }
        
        try await FirestoreConstants.userRef.document(auth.uid).setData(userData, merge: false)
    }
    
    //MARK: - GET USER DATA IN FIRESTORE - async iin call in database and if return error ( add async throw )
    func getUser(userID: String) async throws -> DBUser {
        //1 link for user doc in firestore -> //get doc in DocumentSnapshot version
        let snapshot = try await FirestoreConstants.userRef.document(userID).getDocument()
        
        //2 data, return data in dictionary -> for created
        guard let data = snapshot.data() else {
            throw URLError(.dataNotAllowed)
        }
        
        guard let userID = data["user_id"] as? String else {
            throw URLError(.dataNotAllowed)
        }
        
        //3 data as in ->
        let isAnonymous = data["is_anonymous"] as? Bool
        let dateCreated = data["date_created"] as? Date
        let email = data["email"] as? String
        let photoURL = data["photo_url"] as? String
        
        return DBUser(userID: userID, isAnonymous: isAnonymous, email: email, photoURL: photoURL, dateCreated: dateCreated)
    }
}


final class AppStorageConstants {
    static let shared = AppStorageConstants()
    private init() {}
    
    @AppStorage("log_status") var log_status: Bool = false
}

struct FirestoreConstants {
    static let userRef = Firestore.firestore().collection("SwiftUIAppFirebase_Users")
}
