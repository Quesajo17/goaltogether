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
    /// isMemberOfGroup function accepts an accountability group, and returns a boolean value if the user has a membership to a group with that Id. It does not pay attention to the status of that membership, it just verifies. It will throw an error if the user or the group is missing an ID.
    /// - parameter group: accepts an accountability group.
    /// - returns: A boolean with "true" if the user has a group membership matching the string ID passed to it. Otherwise returns false.
    func isMemberOfGroup(group accountabilityGroup: AccountabilityGroup) throws -> Bool {
        let groupId = accountabilityGroup.id
        
        guard groupId != nil else {
            throw AddingUserToGroupError.groupMissingId
        }
        
        guard self.groupMembership != nil else {
            return false
        }
        
        if ((self.groupMembership?.contains(where: { $0.groupId == groupId })) != nil) {
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
