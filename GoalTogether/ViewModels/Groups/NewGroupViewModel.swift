//
//  NewGroupViewModel.swift
//  GoalTogether
//
//  Created by Charlie Page on 7/10/21.
//

import Foundation
import Combine




class NewGroupViewModel: ObservableObject {
    
    @Published var groupRepository: GroupStoreType
    @Published var groupUserRepository: GroupUserStoreType
    
    @Published var group: AccountabilityGroup
    @Published var pendingInvitees: [UserProfile] = [UserProfile]()
    @Published var currentUser: CurrentUserType
    
    @Published var pendingInviteeViewModels: [UserCellViewModel] = [UserCellViewModel]()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(groupRepository: GroupStoreType, groupUserRepository: GroupUserStoreType, currentUser: CurrentUserType = CurrentUserProfile.shared) {
        self.groupRepository = groupRepository
        self.groupUserRepository = groupUserRepository
        self.group = AccountabilityGroup()
        self.currentUser = currentUser
        self.pendingInvitees.append(currentUser.currentUser!)
        
        subscribeToPendingUserCells()
    }
    
    func subscribeToPendingUserCells() {
        self.$pendingInvitees.map { users in
            users.map { user in
                UserCellViewModel(user: user, group: self.group)
            }
        }
        .assign(to: \.pendingInviteeViewModels, on: self)
        .store(in: &cancellables)
    }

    func addUser(_ user: UserProfile) throws {
        guard pendingInvitees.contains(user) == false else {
            throw AddingUserToGroupError.userAlreadyAdded
        }
        pendingInvitees.append(user)
    }
    
    
    
    func saveGroup() throws {
        self.group.members = addPendingUsersToGroup(pendingInvitees)
        
        do {
            group.id = try groupRepository.addGroup(group)
        } catch {
            print(error)
        }

        
        for userProfile in pendingInvitees {
            var userIsMe: Bool = false
            if userProfile.id == currentUser.currentUser?.id && userProfile.id != nil {
                userIsMe = true
            }
            sendInvitation(user: userProfile, userIsMe: userIsMe)
        }
    }
    
    /// The addPendingUsersToGroup function will take all users in a list (meant to take all users from pendingInvitees) and add them to the group.members array in the existing group.
    /// - parameter _users: This is a blank parameter that takes a list of user profiles, and converts them to a user membership.
    /// - returns: This returns an array of UserMemberships which can be added to an AccountabilityGroup's "members" property.
    private func addPendingUsersToGroup(_ users: [UserProfile]) -> [UserMembership] {
        var groupMembers: [UserMembership] = [UserMembership]()
        
        for userProfile in users {
            var userIsMe: Bool = false
            if userProfile.id == currentUser.currentUser?.id && userProfile.id != nil {
                userIsMe = true
            }
            groupMembers.append(UserMembership(userId: userProfile.id!, membershipStatus: userIsMe == true ? .active : .pending))
        }
        return groupMembers
    }
    

    /// The sendInvitation function will add the current user to the
    private func sendInvitation(user: UserProfile, userIsMe: Bool) {
        
        // Create a group membership, set the membership status to pending, or active if it's my user.
        var groupMembership: GroupMembership
        var membershipStatus: GroupMembershipStatus = .pending
        
        if userIsMe == true {
            membershipStatus = .active
        }
    
        groupMembership = GroupMembership(groupId: group.id!,
                                          groupName: group.title,
                                          membershipStatus: membershipStatus)
        
        var groupMemberships = user.groupMembership
        
        // Create a group memberships array that starts with the user's current group memberships, and adds a membership for this one as long as it doesn't exist. If the user already has a membership set to this group, then it should just return.
        if groupMemberships == nil {
            groupMemberships = [groupMembership]
        } else {
            guard groupMemberships!.contains(where: { $0.groupId == groupMembership.groupId
            }) == false else {
                return
            }
            groupMemberships!.append(groupMembership)
        }
        
        // if it's my user, update the current user by adding this GroupMemberships array.
        if userIsMe == true {
            do {
                try currentUser.updateCurrentUserItems(firstName: nil, lastName: nil, email: nil, phoneNumber: nil, birthday: nil, defaultSeason: nil, seasonLength: nil, groupMembership: groupMemberships)
            } catch {
                fatalError("Could not send the invitation")
            }
        }
        
        if userIsMe == false {
            do {
                try groupUserRepository.updateUserMemberships(userAndMemberships: try groupUserRepository.sendNewInvitation(user: user, group: group))
            } catch {
                print(error.localizedDescription)
                return
            }
        }
    }
}
