//
//  AccountabilityGroup.swift
//  GoalTogether
//
//  Created by Charlie Page on 4/3/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

enum GroupMembershipStatus: String, Codable {
    case pending, active, rejected
}

struct AccountabilityGroup: Codable, Identifiable, Equatable {
    static func == (lhs: AccountabilityGroup, rhs: AccountabilityGroup) -> Bool {
        return lhs.id != nil && lhs.id == rhs.id && lhs.title == rhs.title && lhs.creationDate == rhs.creationDate && lhs.activeMembers == rhs.activeMembers && lhs.pendingMembers == rhs.pendingMembers
    }
    
    @DocumentID var id: String?
    var title: String?
    var description: String?
    var creationDate: Date?
    
    // members
    var activeMembers: [String]?
    var pendingMembers: [String]?
    
    init() {
        self.creationDate = Date()
    }
    
    init(id: String?, title: String?, description: String?, creationDate: Date?, activeMembers: [String]?, pendingMembers: [String]?) {
        self.id = id
        self.title = title
        self.description = description
        if creationDate == nil {
            self.creationDate = Date()
        } else {
            self.creationDate = creationDate
        }
        self.activeMembers = activeMembers
        self.pendingMembers = pendingMembers
    }
}

struct UserMembership: Codable, Equatable {
    var userId: String
    var membershipStatus: GroupMembershipStatus
}

extension AccountabilityGroup {
    /// isUserInGroup function accepts a user, and returns a boolean value if the group has a user matching that ID listed as a member. It does not pay attention to the status of that membership, it just verifies. If the user has no ID, it will throw an error.
    /// - parameter user: Accepts a UserProfile
    /// - returns: A boolean with "true" if the group has a member matching the ID of the user passed to it. Otherwise returns false.
    func isUserInGroup(user: UserProfile) throws -> Bool {
        let userId = user.id
        
        guard userId != nil else {
            throw AddingUserToGroupError.userMissingId
        }
        
        guard self.activeMembers != nil || self.pendingMembers != nil else {
            return false
        }
        
        if ((self.activeMembers?.contains(where: { $0 == userId })) == true) {
            return true
        } else if ((self.pendingMembers?.contains(where: { $0 == userId })) == true) {
            return true
        } else {
            return false
        }
    }
    
    func idCheckForUpdatingMembership(_ user: UserProfile) throws -> Bool {
        
        guard self.id != nil else {
            throw ErrorUpdatingGroupMembership.groupHasNoId
        }
        
        guard user.id != nil else {
            throw ErrorUpdatingGroupMembership.userHasNoId
        }
        
        return true
    }
}
