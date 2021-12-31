//
//  GroupStoreType.swift
//  GoalTogether
//
//  Created by Charlie Page on 7/6/21.
//

import Foundation

protocol GroupStoreType {

    var activeGroups: [AccountabilityGroup] { get set }
    var activeGroupsPublished: Published<[AccountabilityGroup]> { get }
    var activeGroupsPublisher: Published<[AccountabilityGroup]>.Publisher { get }
    
    var pendingGroups: [AccountabilityGroup] { get set }
    var pendingGroupsPublished: Published<[AccountabilityGroup]> { get }
    var pendingGroupsPublisher: Published<[AccountabilityGroup]>.Publisher { get }
    
    func addGroup(_ accountabilityGroup: AccountabilityGroup) throws -> String
    func updateGroup(_ accountabilityGroup: AccountabilityGroup)
    func deleteGroup(_ accountabilityGroup: AccountabilityGroup)
    
    func endListening()
    
    func updateMembers(group accountabilityGroup: AccountabilityGroup) throws
    func sendNewInvitation(group accountabilityGroup: AccountabilityGroup, user: UserProfile) throws -> (AccountabilityGroup)
    func activatePendingUser(group accountabilityGroup: AccountabilityGroup, user: UserProfile) throws -> (AccountabilityGroup)
    func removeMemberFromGroup(group accountabilityGroup: AccountabilityGroup, user: UserProfile) throws -> (AccountabilityGroup)
}

extension GroupStoreType {
    
    func updateMembers(group accountabilityGroup: AccountabilityGroup) throws {
        guard accountabilityGroup.id != nil else {
            throw ErrorUpdatingGroupMembership.groupHasNoId
        }
        
        var groupForUpdate: AccountabilityGroup
        
        if self.activeGroups.contains(where: { $0.id == accountabilityGroup.id }) {
            groupForUpdate = self.activeGroups.first(where: { $0.id == accountabilityGroup.id })!
        } else if self.pendingGroups.contains(where: { $0.id == accountabilityGroup.id }) {
            groupForUpdate = self.pendingGroups.first(where: {$0.id == accountabilityGroup.id })!
        } else {
            throw ErrorUpdatingGroupMembership.groupCouldNotBeFound
        }
        
        groupForUpdate.activeMembers = accountabilityGroup.activeMembers
        groupForUpdate.pendingMembers = accountabilityGroup.pendingMembers
        
        updateGroup(groupForUpdate)
    }
    
    /// The sendNewInvitation function takes a user and a group, and returns the group and it's current group member arrays with a pending invitation to the specified user added.
    /// - parameter group: This accepts an accountabilityGroup
    /// - parameter user: This accepts a userProfile
    /// - returns: Returns a tuple containing an accountabilityGroup and an array of active members and pending members with the group's current members with a pending member added for this particular user.
    func sendNewInvitation(group accountabilityGroup: AccountabilityGroup, user: UserProfile) throws -> (AccountabilityGroup) {
        
        do {
            let _ = try accountabilityGroup.idCheckForUpdatingMembership(user)
        } catch {
            throw error
        }
        
        var updatingGroup = accountabilityGroup
        
        guard updatingGroup.activeMembers?.contains(where: { $0 == user.id }) != true && updatingGroup.pendingMembers?.contains(where: { $0 == user.id }) != true else {
            throw ErrorUpdatingGroupMembership.userAlreadyInvited
        }
        
        if updatingGroup.pendingMembers == nil {
            updatingGroup.pendingMembers = [user.id!]
        } else {
            updatingGroup.pendingMembers!.append(user.id!)
        }
        
        return updatingGroup
    }
    
    /// The activatePendingUser function takes a user and a group, and removes the user from the pending members list, and adds them to the active users list.
    /// - parameter group: This accepts an accountabilityGroup
    /// - parameter user: This accepts a userProfile
    /// - returns: Returns
    func activatePendingUser(group accountabilityGroup: AccountabilityGroup, user: UserProfile) throws -> (AccountabilityGroup) {
        
        var updatingGroup = accountabilityGroup
        
        do {
            let _ = try accountabilityGroup.idCheckForUpdatingMembership(user)
        } catch {
            throw error
        }
        
        guard updatingGroup.activeMembers?.contains(where: { $0 == user.id }) != true else {
            throw ErrorUpdatingGroupMembership.userAlreadyActive
        }
        
        guard updatingGroup.pendingMembers?.contains(where: { $0 == user.id }) == true else {
            throw ErrorUpdatingGroupMembership.noPendingInviteToActivate
        }
        
        if updatingGroup.activeMembers == nil {
            updatingGroup.activeMembers = [user.id!]
        } else {
            updatingGroup.activeMembers!.append(user.id!)
        }
        updatingGroup.pendingMembers?.removeAll(where: { $0 == user.id })
        
        return updatingGroup
    }
    
    /// The removeMemberFromGroup function takes a user and a group and returns the group and its member array with the specified user removed.
    /// - parameter group: This accepts an accountabilityGroup
    /// - parameter user: This accepts a userProfile
    /// - returns: If the user is currently in the group, this returns the group and its member array with the current user removed.
    func removeMemberFromGroup(group accountabilityGroup: AccountabilityGroup, user: UserProfile) throws -> (AccountabilityGroup) {
        
        var updatingGroup = accountabilityGroup
        
        do {
            let _ = try accountabilityGroup.idCheckForUpdatingMembership(user)
        } catch {
            throw error
        }
        
        guard (updatingGroup.activeMembers?.contains(where: { $0 == user.id }) == true) || (updatingGroup.pendingMembers?.contains(where: { $0 == user.id }) == true) else {
            throw ErrorUpdatingGroupMembership.groupHasNoMember
        }
        
        updatingGroup.activeMembers?.removeAll(where: { $0 == user.id })
        updatingGroup.pendingMembers?.removeAll(where: { $0 == user.id })
        
        return updatingGroup
    }
}
