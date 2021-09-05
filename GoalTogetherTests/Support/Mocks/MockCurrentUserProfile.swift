//
//  MockCurrentUserProfile.swift
//  GoalTogetherTests
//
//  Created by Charlie Page on 6/8/21.
//

import Foundation
@testable import GoalTogether

class MockCurrentUserProfile: ObservableObject, CurrentUserType {

    
    
    @Published var currentUser: UserProfile?
    var currentUserPublished: Published<UserProfile?> { _currentUser }
    var currentUserPublisher: Published<UserProfile?>.Publisher { $currentUser }
    
    init() {
        self.currentUser = TestUserProfile().userProfile
    }
    
    func updateCurrentUserItems(firstName: String?, lastName: String?, email: String?, phoneNumber: String?, birthday: Date?, defaultSeason: String?, seasonLength: SeasonLength?, groupMembership: [GroupMembership]?) throws {
            let currentUser = self.currentUser
            
            guard currentUser != nil else {
                throw UserProfileError.noUserProfileToUpdate
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
            }
        }
    
    func updateCurrentUserFromUser(_ userProfile: UserProfile) throws {
        let currentUser = self.currentUser
        let updatedUser = userProfile
        
        guard currentUser != nil else {
            throw UserProfileError.noUserProfileToUpdate
        }
        
        guard currentUser!.id == updatedUser.id else {
            throw UserProfileError.newOldIDMismatch
        }
        
        if updatedUser == currentUser! {
            return
        } else {
            self.currentUser = updatedUser
        }
    }
}
    

