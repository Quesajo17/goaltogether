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
import SDWebImage
import SDWebImageSwiftUI


class UserProfileViewModel: ObservableObject {
    
    
    @Published var editingProfile: UserProfile
    @ObservedObject var originalProfile = CurrentUserProfile.shared
    
    
    @Published var originalImageURL: String = ""
    @Published var selectedImage: UIImage?
    
    
    init() {
        
        self.editingProfile = CurrentUserProfile.shared.currentUser ?? CurrentUserProfile.shared.userProfileUsingAuthUser()
        
        if editingProfile.profileImagePhoto != nil {
            self.loadImageFromFirebase()
        }
        
        
    }
    
    func saveEditingProfile() {
        do {
            try originalProfile.updateCurrentUserFromUser(self.editingProfile)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    func loadImageFromFirebase() {
        if let profileImageURL = editingProfile.profileImagePhoto {
            let httpsReference = Storage.storage().reference(forURL: profileImageURL)
            
            httpsReference.downloadURL { url, error in
                if let error = error {
                    print(error)
                } else {
                    guard let imageURL = url?.absoluteString else {
                        return
                    }
                    self.originalImageURL = imageURL
                }
            }
        } else {
            return
        }
    }
}
