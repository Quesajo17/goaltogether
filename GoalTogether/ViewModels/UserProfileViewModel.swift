//
//  UserProfileViewModel.swift
//  GoalTogether
//
//  Created by Charlie Page on 4/16/21.
//

import Foundation
import Combine
import Firebase
import SwiftUI

class UserProfileViewModel: ObservableObject {
    
    @Published var loggedInUser: User?
    @Published var userProfile: UserProfile?
    
    @Published var originalImage: UIImage?
    @Published var selectedImage: UIImage?
    
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    private var cancellable = Set<AnyCancellable>()
    
    
    init() {
        
        // Subscribes to the logged in user in Authentication state, and sets user profile/loggedInUser in the view model based on that logged in user.
        AuthenticationState.shared.$loggedInUser
            .print()
            .sink { [weak self] user in
                print("User ID from Authentication State is now to the VM as \(String(describing: user?.uid))")
                self?.loadUser()
                self?.loggedInUser = user
            }
            .store(in: &cancellable)
    }
    
    
    func loadUser() {
        let userId = auth.currentUser?.uid
        print("user ID for loadUser function is now \(String(describing: userId))")
        var profile: UserProfile? = nil
        
        if userId != nil {
            let docReference = db.collection("users").document(userId!)
            docReference.getDocument { (document, error) in
                let result = Result {
                    try document?.data(as: UserProfile.self)
                }
                switch result {
                case .success(let userProfile):
                    if userProfile != nil {
                        profile = userProfile
                        print("set profile to existing profile")
                        self.userProfile = profile
                    } else {
                        let newUser = self.userProfileUsingAuthUser()
                        self.createFirestoreUser(newUser)
                        profile = newUser
                        print("LoadUser function: created new Firestore User")
                        self.userProfile = profile
                    }
                case .failure(let error):
                    print("Error decoding profile: \(error)")
                }
            }
        } else {
            self.userProfile = nil
        }
        return
    }
    
    func createFirestoreUser(_ user: UserProfile) {
        do {
            let newDocRef: () = try db.collection("users").document(user.id!).setData(from: user)
            print("New Document ID is \(newDocRef)")
        } catch {
            fatalError("Unable to encode user: \(error.localizedDescription)")
        }
    }
    
    func userProfileUsingAuthUser() -> UserProfile {
        let id = self.loggedInUser?.uid
        let name = self.loggedInUser?.displayName
        let email = self.loggedInUser?.email
        let phoneNumber = self.loggedInUser?.phoneNumber
        
        return UserProfile(id: id, firstName: name, email: email, phoneNumber: phoneNumber)
    }
    
    func updateUser(_ userProfile: UserProfile) {
        verifyMatch(userProfile)
        if let profileId = userProfile.id {
            do {
                try db.collection("users").document(profileId).setData(from: userProfile)
                print("Successful, I think.")
                loadUser()
            } catch {
                fatalError("Unable to encode user: \(error.localizedDescription)")
            }
        }
    }
    
    func verifyMatch(_ userProfile: UserProfile) {
        let profileId = userProfile.id
        let authId = self.loggedInUser?.uid
        
        guard profileId != nil else { fatalError("User Profile Id is nil")}
        guard authId != nil else { fatalError("auth Id is nil")}
        guard profileId == authId else { fatalError("Profile Id and Auth Id don't match")}
        
        print("Match verified with current profile. Works.")
        return
    }
    
    func saveImagetoFirebase(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.4) else {
            return
        }
        
        let reference = getStorageRef(for: self.userProfile!)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        reference.putData(imageData, metadata: metadata, completion: {
            (storageMetaData, error) in
            if error != nil {
                print(error?.localizedDescription)
                return
            }
        })
        
        reference.downloadURL(completion: { (url, error) in
            if let metaImageUrl = url?.absoluteString {
                print(metaImageUrl)
                self.userProfile?.profileImagePhoto = metaImageUrl
            }
        })
        
    }
    
    func getStorageRef(for userProfile: UserProfile) -> StorageReference {
        guard let id = userProfile.id else {
            print("UserProfile ID is nil")
            return Storage.storage().reference(forURL: "gs://goal-sharing-app.appspot.com")
        }
        
        let storageRef = Storage.storage().reference(forURL: "gs://goal-sharing-app.appspot.com")
        
        let storageProfileRef = storageRef.child("profile").child(id)
        
        return storageProfileRef
    }
}
