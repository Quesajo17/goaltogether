//
//  UserCellViewModel.swift
//  GoalTogether
//
//  Created by Charlie Page on 7/12/21.
//

import Foundation
import Combine
import Firebase
import SwiftUI
import SDWebImage
import SDWebImageSwiftUI

class UserCellViewModel: ObservableObject, Identifiable {
    // @Published var userRepository: UserStoreType
    @Published var user: UserProfile
    
    @Published var imageURL: String = ""
    
    var group: AccountabilityGroup?
    var userMembershipStatus: GroupMembershipStatus?
    var name: String?
    
    init(user: UserProfile) {
        // self.userRepository = userRepository
        self.user = user
        self.name = setName()
        
        if user.profileImagePhoto != nil {
            self.loadUserImageFromFirebase()
        }
    }
    
    init(user: UserProfile, group accountabilityGroup: AccountabilityGroup) {
        // self.userRepository = userRepository
        self.user = user
        self.group = accountabilityGroup
        self.name = setName()
        
        if user.profileImagePhoto != nil {
            self.loadUserImageFromFirebase()
        }
        
        
        
        
    }
    
    // make this function calculate the user's membership status - I think I have another function to do this.
    func userGroupStatus() -> GroupMembershipStatus? {
        return nil
    }
    
    // Probably need some way of loading their Firebase image in here. Or having that available in the userstoretype.
    private func loadUserImageFromFirebase() {
        if let profileImageURL = user.profileImagePhoto {
            let httpsReference = Storage.storage().reference(forURL: profileImageURL)
            
            httpsReference.downloadURL { url, error in
                if let error = error {
                    print(error)
                } else {
                    guard let imageURL = url?.absoluteString else {
                        return
                    }
                    self.imageURL = imageURL
                }
            }
        } else {
            return
        }
    }
    
    private func setName() -> String? {
        var realName: String? = nil
        
        if user.firstName != nil && user.lastName != nil {
            realName = "\(user.firstName!) \(user.lastName!)"
        } else if user.firstName != nil {
            realName = user.firstName!
        }
        
        return realName
    }
}
