//
//  GroupStoreType.swift
//  GoalTogether
//
//  Created by Charlie Page on 7/6/21.
//

import Foundation

protocol GroupStoreType {

    var accountabilityGroups: [AccountabilityGroup] { get set }
    var accountabilityGroupsPublished: Published<[AccountabilityGroup]> { get }
    var accountabilityGroupsPublisher: Published<[AccountabilityGroup]>.Publisher { get }
    
    func addGroup(_ accountabilityGroup: AccountabilityGroup) throws -> String
    func updateGroup(_ accountabilityGroup: AccountabilityGroup)
    func deleteGroup(_ accountabilityGroup: AccountabilityGroup)
    
    func endListening()
    
    func updateMembers(groupAndMembers: (AccountabilityGroup, [UserMembership])) throws
    func sendNewInvitation(group accountabilityGroup: AccountabilityGroup, user: UserProfile) throws -> (AccountabilityGroup, [UserMembership])
    func updateMembershipStatus(group accountabilityGroup: AccountabilityGroup, user: UserProfile, newStatus: GroupMembershipStatus) throws -> (AccountabilityGroup, [UserMembership])
    func removeMemberFromGroup(group accountabilityGroup: AccountabilityGroup, user: UserProfile) throws -> (AccountabilityGroup, [UserMembership])
    func updateGroupName(group accountabilityGroup: AccountabilityGroup, newName: String) throws -> (AccountabilityGroup, [UserMembership])
}

extension GroupStoreType {
    
    func updateMembers(groupAndMembers: (AccountabilityGroup, [UserMembership])) throws {
        var updatedGroup = groupAndMembers.0
        
        updatedGroup.members = groupAndMembers.1
        
        updateGroup(updatedGroup)
    }
    
    /// The sendNewInvitation function takes a user and a group, and returns the group and it's current group member array with a pending invitation to the specified user added.
    /// - parameter group: This accepts an accountabilityGroup
    /// - parameter user: This accepts a userProfile
    /// - returns: Returns a tuple containing an accountabilityGroup and an array of groupMembers containing the group's current members with a pending member added for this particular user.
    func sendNewInvitation(group accountabilityGroup: AccountabilityGroup, user: UserProfile) throws -> (AccountabilityGroup, [UserMembership]) {
        
        do {
            let _ = try accountabilityGroup.idCheckForUpdatingMembership(user)
        } catch {
            throw error
        }
        
        let originalMembers = accountabilityGroup.members
        var newMembershipSet = originalMembers
        
        let index = newMembershipSet?.firstIndex(where: { $0.userId == user.id })
        
        guard index == nil else {
            throw ErrorUpdatingGroupMembership.userAlreadyInvited
        }
        
        let newMembership = UserMembership(userId: user.id!, membershipStatus: .pending)
        
        if newMembershipSet == nil {
            newMembershipSet = [newMembership]
        } else {
            newMembershipSet!.append(newMembership)
        }
        
        return (accountabilityGroup, newMembershipSet!)
    }
    
    /// The updatedMembershipStatus function takes a user, a group, and a membershipStatus, and returns the group and it's current group member array with the specified user's status updated to match the newStatus as specified.
    /// - parameter group: This accepts an accountabilityGroup
    /// - parameter user: This accepts a userProfile
    /// - parameter newStatus: This acceps a GroupMembershipStatus (.active, .pending, or .rejected)
    /// - returns: If the newStatus is different than the group member's current status, this returns a tuple containing the group, and the group's updated memberships.
    func updateMembershipStatus(group accountabilityGroup: AccountabilityGroup, user: UserProfile, newStatus: GroupMembershipStatus) throws -> (AccountabilityGroup, [UserMembership]) {
        
        do {
            let _ = try accountabilityGroup.idCheckForUpdatingMembership(user)
        } catch {
            throw error
        }
        
        let originalMembershipSet = accountabilityGroup.members
        var newMembershipSet = originalMembershipSet
        
        let index = newMembershipSet?.firstIndex(where: { $0.userId == user.id })
        
        guard index != nil else {
            throw ErrorUpdatingGroupMembership.groupHasNoMember
        }
        
        guard newMembershipSet![index!].membershipStatus != newStatus else {
            throw ErrorUpdatingGroupMembership.updatesMatchCurrentMember
        }
        
        newMembershipSet![index!].membershipStatus = newStatus
        
        return (accountabilityGroup, newMembershipSet!)
    }
    
    /// The removeMemberFromGroup function takes a user and a group and returns the group and its member array with the specified user removed.
    /// - parameter group: This accepts an accountabilityGroup
    /// - parameter user: This accepts a userProfile
    /// - returns: If the user is currently in the group, this returns the group and its member array with the current user removed.
    func removeMemberFromGroup(group accountabilityGroup: AccountabilityGroup, user: UserProfile) throws -> (AccountabilityGroup, [UserMembership]) {
        
        do {
            let _ = try accountabilityGroup.idCheckForUpdatingMembership(user)
        } catch {
            throw error
        }
        
        let originalMemberSet = accountabilityGroup.members
        var newMembershipSet = originalMemberSet
        
        let index = newMembershipSet?.firstIndex(where: { $0.userId == user.id })
        
        guard index != nil else {
            throw ErrorUpdatingGroupMembership.groupHasNoMember
        }
        
        newMembershipSet!.removeAll(where: { $0.userId == user.id })
        
        return (accountabilityGroup, newMembershipSet!)
    }
    
    /// The updateGroupName function takes an accountability group and a new name as a string value, and returns a tuple with the group and an updated name, along with the group's member list.
    /// - parameter group: This accepts an accountabilityGroup
    /// - parameter newName: This accepts a string value for the group's new name
    /// - returns: This returns a tuple with the accountability group with an updated name (matching the newName), and the group's list of members.
    func updateGroupName(group accountabilityGroup: AccountabilityGroup, newName: String) throws -> (AccountabilityGroup, [UserMembership]) {
        
        guard accountabilityGroup.id != nil else {
            throw ErrorUpdatingGroupMembership.groupHasNoId
        }
        
        var memberSet: [UserMembership]
        var updatedGroup = accountabilityGroup
        
        updatedGroup.title = newName
            
        if accountabilityGroup.members != nil {
            memberSet = accountabilityGroup.members!
        } else {
            memberSet = [UserMembership]()
        }
        
        return (updatedGroup, memberSet)
    }
}
