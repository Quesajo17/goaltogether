//
//  GroupMemberStoreType.swift
//  GoalTogether
//
//  Created by Charlie Page on 7/27/21.
//

import Foundation
import Combine

protocol GroupUserStoreType {
    
    var membersWithStatus: [(UserProfile, GroupMembershipStatus)] { get set }
    var membersWithStatusPublished: Published<[(UserProfile, GroupMembershipStatus)]> { get }
    var membersWithStatusPublisher: Published<[(UserProfile, GroupMembershipStatus)]>.Publisher { get }
    
    var groupId: String? { get set }
    
    
    func loadGroupMembers() -> AnyPublisher<Bool, Never>

    func updateUserMemberships(userAndMemberships: (UserProfile, [GroupMembership])) throws
    func sendNewInvitation(user: UserProfile, group: AccountabilityGroup) throws -> (UserProfile, [GroupMembership])
    func updateMembershipStatus(user: UserProfile, group: AccountabilityGroup, newStatus: GroupMembershipStatus) throws -> (UserProfile, [GroupMembership])
    func removeMembershipFromUser(user: UserProfile, group: AccountabilityGroup) throws -> (UserProfile, [GroupMembership])
    func updateMembershipGroupName(user: UserProfile, group: AccountabilityGroup, newName: String) throws -> (UserProfile, [GroupMembership])

    
    func endListening()
}



extension GroupUserStoreType {
    /// The sendNewInvitation function takes a user and a group, and returns the user and their current group membership array with a pending invitation to the specified group added.
    /// - parameter user: This accepts a userProfile
    /// - parameter group: This accepts an accountabilityGroup
    /// - returns: Returns a tuple containing a UserProfile and an array of groupMemberships containing the user's current group memberships with a new pending invitation to the specified group added.
    func sendNewInvitation(user: UserProfile, group: AccountabilityGroup) throws -> (UserProfile, [GroupMembership]) {

        do {
            let _ = try user.idCheckForUpdatingMembership(group)
        } catch {
            throw error
        }
        
        let originalMembershipSet = user.groupMembership
        var newMembershipSet = originalMembershipSet
        
        let index = newMembershipSet?.firstIndex(where: { $0.groupId == group.id })
        
        guard index == nil else {
            throw ErrorUpdatingUserMembership.userAlreadyInvited
        }
        
        let newMembership = GroupMembership(groupId: group.id!, groupName: group.title, membershipStatus: .pending)
        
        if newMembershipSet == nil {
            newMembershipSet = [newMembership]
        } else {
            newMembershipSet!.append(newMembership)
        }
        
        return (user, newMembershipSet!)
    }
    
    /// The updateMembershipStatus function takes a user and a group, and returns the user and their groupMemberships with the status for the specified group updated.
    /// - parameter user: This accepts a userProfile
    /// - parameter group: This accepts an accountabilityGroup
    /// - parameter newStatus: This accepts a groupMembership status
    /// - returns: Returns a tuple containing a UserProfile and an array of groupMemberships containing the user's current group memberships, with an updated status for the specified group matching the specified status.
    func updateMembershipStatus(user: UserProfile, group: AccountabilityGroup, newStatus: GroupMembershipStatus) throws -> (UserProfile, [GroupMembership]) {

        do {
            let _ = try user.idCheckForUpdatingMembership(group)
        } catch {
            throw error
        }
        
        let originalMembershipSet = user.groupMembership
        var newMembershipSet = originalMembershipSet
        
        let index = newMembershipSet?.firstIndex(where: { $0.groupId == group.id })
        
        guard index != nil else {
            throw ErrorUpdatingUserMembership.userHasNoMembership
        }
        
        guard newMembershipSet![index!].membershipStatus != newStatus else {
            throw ErrorUpdatingUserMembership.updatesMatchCurrentUserMemberships
        }
        
        newMembershipSet![index!].membershipStatus = newStatus
        
        return (user, newMembershipSet!)
    }
    
    /// The removeMembershipFromUser function takes a user and a group, and returns the user and their group memberships, removing the membership to the specified group.
    /// - parameter user: This accepts a userProfile
    /// - parameter group: This accepts an accountabilityGroup
    /// - returns: Returns a tuple containing a UserProfile and an array of groupMemberships containing the user's current group memberships with the group from the parameter removed.
    func removeMembershipFromUser(user: UserProfile, group: AccountabilityGroup) throws -> (UserProfile, [GroupMembership]) {
        
        do {
            let _ = try user.idCheckForUpdatingMembership(group)
        } catch {
            throw error
        }
        
        let originalMembershipSet = user.groupMembership
        var newMembershipSet = originalMembershipSet
        
        guard newMembershipSet != nil else {
            throw ErrorUpdatingUserMembership.userHasNoMembership
        }
        
        newMembershipSet!.removeAll(where: { $0.groupId == group.id })
        
        return (user, newMembershipSet!)
    }
    
    /// The updateMembershipGroupName function takes a user and a group, and returns the user and their group memberships, updating the name of the group in their membership to reflect the group's new name.
    /// - parameter user: This accepts a userProfile
    /// - parameter group: This accepts an accountabilityGroup
    /// - parameter newName: This accepts a string for the group's new name.
    /// - returns: Returns a tuple containing a UserProfile and an array of groupMemberships containing the user's current group memberships with the group membership tied to the specified group updated to reflect the group's current name.
    func updateMembershipGroupName(user: UserProfile, group: AccountabilityGroup, newName: String) throws -> (UserProfile, [GroupMembership]) {

        do {
            let _ = try user.idCheckForUpdatingMembership(group)
        } catch {
            throw error
        }
        
        let originalMembershipSet = user.groupMembership
        var newMembershipSet = originalMembershipSet
        
        let index = newMembershipSet?.firstIndex(where: { $0.groupId == group.id })
        
        guard index != nil else {
            throw ErrorUpdatingUserMembership.userHasNoMembership
        }
        
        newMembershipSet![index!].groupName = newName
        
        return (user, newMembershipSet!)
    }
}
