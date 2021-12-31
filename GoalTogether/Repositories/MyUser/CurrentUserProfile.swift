//
//  CurrentUserProfile.swift
//  GoalTogether
//
//  Created by Charlie Page on 5/8/21.
//

import Foundation
import Firebase
import FirebaseFirestore
import Combine

class CurrentUserProfile: NSObject, ObservableObject, CurrentUserType {
    
    @Published var currentUser: UserProfile?
    var currentUserPublished: Published<UserProfile?> { _currentUser }
    var currentUserPublisher: Published<UserProfile?>.Publisher { $currentUser }
    
    static let shared = CurrentUserProfile()
    
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    private var cancellables = Set<AnyCancellable>()
    
    override init() {
        super.init()
            // Subscribes to the logged in user in Authentication state, and sets user profile/loggedInUser in the view model based on that logged in user.
            AuthenticationState.shared.$loggedInUser
                .dropFirst()
                .sink { [weak self] user in
                    print("Authentication state has changed. Setting UserProfile to this uid: \(String(describing: user?.uid))")
                    self?.loadUser()
                    // self?.loadImageFromFirebase()
                }
                .store(in: &cancellables)
    }
    
    func loadUser() {
        let userId = auth.currentUser?.uid
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
                        self.currentUser = profile
                        // self.loadImageFromFirebase()
                    } else {
                        let newUser = self.userProfileUsingAuthUser()
                        self.createFirestoreUser(newUser)
                        profile = newUser
                        self.currentUser = profile

                    }
                case .failure(let error):
                    print("Error decoding profile: \(error)")
                }
            }
        } else {
            self.currentUser = nil
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
        let id = AuthenticationState.shared.loggedInUser?.uid
        let name = AuthenticationState.shared.loggedInUser?.displayName
        let email = AuthenticationState.shared.loggedInUser?.email
        let phoneNumber = AuthenticationState.shared.loggedInUser?.phoneNumber
        
        return UserProfile(id: id, firstName: name, email: email, phoneNumber: phoneNumber)
    }
    
    public func updateCurrentUserFromUser(_ userProfile: UserProfile) throws {
        let currentUser = self.currentUser
        let updatedUser = userProfile
        
        guard currentUser != nil else {
            throw UserProfileError.noUserProfileToUpdate
        }
        
        guard currentUser!.id == auth.currentUser?.uid && currentUser!.id != nil else {
            throw UserProfileError.authUserProfileMismatch
        }
        
        guard currentUser!.id == updatedUser.id else {
            throw UserProfileError.newOldIDMismatch
        }
        
        if updatedUser == currentUser! {
            return
        } else {
            self.currentUser = updatedUser
            self.updateUser(updatedUser)
        }
    }
    
    public func updateCurrentUserItems(firstName: String?, lastName: String?, email: String?, phoneNumber: String?, birthday: Date?, defaultSeason: String?, seasonLength: SeasonLength?, groupMembership: [GroupMembership]?) throws {
        let currentUser = self.currentUser
        
        guard currentUser != nil else {
            throw UserProfileError.noUserProfileToUpdate
        }
        
        guard currentUser!.id == auth.currentUser?.uid && currentUser!.id != nil else {
            throw UserProfileError.authUserProfileMismatch
        }
        
        var updatedUser = currentUser!
        
        if firstName != nil {
            updatedUser.firstName = firstName
        }
        if lastName != nil {
            updatedUser.lastName = lastName
        }
        
        if email != nil {
            updatedUser.email = email
        }
        
        if phoneNumber != nil {
            updatedUser.phoneNumber = phoneNumber
        }
        
        if birthday != nil {
            updatedUser.birthday = birthday
        }
        
        if defaultSeason != nil {
            updatedUser.defaultSeason = defaultSeason
        }
        
        if seasonLength != nil {
            updatedUser.seasonLength = seasonLength
        }
        
        if groupMembership != nil {
            updatedUser.groupMembership = groupMembership
        }
        
        if updatedUser == currentUser! {
            return
        } else {
            self.currentUser = updatedUser
            self.updateUser(updatedUser)
        }
    }
    
    private func updateUser(_ userProfile: UserProfile) {
        if let profileId = userProfile.id {
            do {
                try db.collection("users").document(profileId).setData(from: userProfile)
            } catch {
                fatalError("Unable to encode user: \(error.localizedDescription)")
            }
        }
    }
    
    func verifyMatch(_ userProfile: UserProfile) -> Bool {
        let profileId = userProfile.id
        let authId = AuthenticationState.shared.loggedInUser?.uid
        
        guard profileId != nil else { return false }
        guard authId != nil else { return false }
        guard profileId == authId else { return false }
        
        return true
    }
    
    func saveImagetoFirebase(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.4) else {
            return
        }
        
        let reference = getStorageRef(for: self.currentUser!)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        reference.putData(imageData, metadata: metadata, completion: {
            (storageMetaData, error) in
            if error != nil {
                print(error?.localizedDescription ?? "Untitled error in attempting to save the profile image to firebase")
                return
            }
        })
        
        reference.downloadURL(completion: { (url, error) in
            if let metaImageUrl = url?.absoluteString {
                print(metaImageUrl)
                self.currentUser?.profileImagePhoto = metaImageUrl
                self.updateUser(self.currentUser!)
            } else {
                print("No image URL")
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
