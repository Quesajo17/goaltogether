//
//  UserSearchRepository.swift
//  GoalTogether
//
//  Created by Charlie Page on 7/15/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase

class UserSearchRepository: ObservableObject, UserStoreType {
    
    let db = Firestore.firestore()
    
    @Published var users: [UserProfile] = [UserProfile]()
    var usersPublished: Published<[UserProfile]> { _users }
    var usersPublisher: Published<[UserProfile]>.Publisher { $users }
    
    init() {
        loadUsers()
    }
    
    func loadUsers() {
        db.collection("users")
            .getDocuments() { (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    self.users = querySnapshot.documents.compactMap { document in
                        do {
                            let x = try document.data(as: UserProfile.self)
                            return x
                        } catch {
                            print("An error has occurred")
                            print(error)
                        }
                        return nil
                    }
                }
            }
    }
    
    func endListening() {
        // stub
    }
    
    
}
