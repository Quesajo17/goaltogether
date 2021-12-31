//
//  CurrentUserType.swift
//  GoalTogether
//
//  Created by Charlie Page on 6/8/21.
//

import Foundation

protocol CurrentUserType {
    
    var currentUser: UserProfile? { get set }
    var currentUserPublished: Published<UserProfile?> { get }
    var currentUserPublisher: Published<UserProfile?>.Publisher { get }
    
    func updateCurrentUserItems(firstName: String?, lastName: String?, email: String?, phoneNumber: String?, birthday: Date?, defaultSeason: String?, seasonLength: SeasonLength?, groupMembership: [GroupMembership]?) throws
    
    func updateCurrentUserFromUser(_ userProfile: UserProfile) throws
    func updateMyMemberships(memberships: [GroupMembership]) throws
    func acceptGroupInvite(group: AccountabilityGroup) throws -> [GroupMembership]
    func declineGroupInvite(group: AccountabilityGroup) throws -> [GroupMembership]
}

extension CurrentUserType {
    
    func updateMyMemberships(memberships: [GroupMembership]) throws {
        var updatingUser = self.currentUser
        
        guard updatingUser != nil else {
            throw ErrorUpdatingUserMembership.userHasNoId
        }
        
        updatingUser!.groupMembership = memberships
        
        do {
            try self.updateCurrentUserFromUser(updatingUser!)
        } catch {
            throw error
        }
    }
    
    func acceptGroupInvite(group: AccountabilityGroup) throws -> [GroupMembership] {
        let groupId = group.id
        
        guard groupId != nil else {
            throw ErrorUpdatingUserMembership.groupHasNoId
        }
        
        var myMemberships = self.currentUser?.groupMembership
        
        // verify there is a first item in myMemberships at a pending status
        let index = myMemberships?.firstIndex(where: { $0.groupId == groupId && $0.membershipStatus == .pending })
        
        guard index != nil else {
            throw ErrorUpdatingUserMembership.userHasNoMembership
        }
        
        myMemberships![index!].membershipStatus = .active
        
        return myMemberships!
    }
    
    func declineGroupInvite(group: AccountabilityGroup) throws -> [GroupMembership] {
        let groupId = group.id
        
        guard groupId != nil else {
            throw ErrorUpdatingUserMembership.groupHasNoId
        }
        
        var myMemberships = self.currentUser?.groupMembership
        
        // verify there is a first item in myMemberships at a pending status
        let index = myMemberships?.firstIndex(where: { $0.groupId == groupId && $0.membershipStatus == .pending })
        
        guard index != nil else {
            throw ErrorUpdatingUserMembership.userHasNoMembership
        }
        
        myMemberships!.removeAll(where: { $0.groupId == groupId && $0.membershipStatus == .pending })
        
        return myMemberships!
    }
}


