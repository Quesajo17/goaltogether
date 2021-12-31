//
//  UserProfile.swift
//  GoalTogether
//
//  Created by Charlie Page on 4/3/21.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

public enum SeasonLength: String, Codable {
    case month, quarter
}


struct UserProfile: Codable, Identifiable, Equatable {
    
    // Identifying Information
    @DocumentID var id: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    var phoneNumber: String?
    var birthday: Date?
    var profileImagePhoto: String?
    
    // Metadata
    var summary: String?
    var defaultSeason: String?
    var seasonLength: SeasonLength?
    
    // Group Membership
    var groupMembership: [GroupMembership]?

}

struct GroupMembership: Codable, Equatable {
    var groupId: String
    var groupName: String?
    var membershipStatus: GroupMembershipStatus
}

extension UserProfile {
    /// isMemberOfGroup function accepts an accountability group, and an optional status and returns a boolean value if the user has a membership to a group with that Id (and with that status if one is passed to the function). It will return false if the group is missing an ID.
    /// - parameter group: accepts an accountability group.
    /// - parameter status: accepts a GroupMembership status to search for. Returns nil if none is passed in.
    /// - returns: A boolean with "true" if the user has a group membership matching the string ID passed to it. Otherwise returns false.
    func isMemberOfGroup(group accountabilityGroup: AccountabilityGroup, status: GroupMembershipStatus? = nil) -> Bool {
        let groupId = accountabilityGroup.id
        
        guard groupId != nil else {
            return false
        }
        
        guard self.groupMembership != nil else {
            return false
        }
        
        let groupMembership = self.groupMembership?.first(where: {$0.groupId == groupId })
        
        guard groupMembership != nil else {
            return false
        }
        
        if status == nil {
            return true
        } else if status == groupMembership!.membershipStatus {
            return true
        } else {
            return false
        }
    }
    
    func idCheckForUpdatingMembership(_ accountabilityGroup: AccountabilityGroup) throws -> Bool {
        
        guard self.id != nil else {
            throw ErrorUpdatingUserMembership.userHasNoId
        }
        
        guard accountabilityGroup.id != nil else {
            throw ErrorUpdatingUserMembership.groupHasNoId
        }
        
        return true
    }
}
