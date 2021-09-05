//
//  GroupHubViewModel.swift
//  GoalTogether
//
//  Created by Charlie Page on 8/23/21.
//

import Foundation
import Combine

class GroupHubViewModel: ObservableObject {
    
    @Published var groupRepository: GroupStoreType
    @Published var currentUser: CurrentUserType
    
    @Published var activeGroupViewModels: [GroupCellViewModel] = [GroupCellViewModel]()
    @Published var pendingInviteViewModels: [GroupCellViewModel] = [GroupCellViewModel]()
    
    private var cancellables = Set<AnyCancellable>()
    
    
    init(groupRepository: GroupStoreType, currentUser: CurrentUserType = CurrentUserProfile.shared) {
        self.groupRepository = groupRepository
        self.currentUser = currentUser
        
        self.loadActiveGroups()
        self.loadPendingGroups()
    }
    
    func loadActiveGroups() {
        self.groupRepository.accountabilityGroupsPublisher.map { groups in
            groups.filter { group in
                if group.members?.contains(where: { $0.userId == self.currentUser.currentUser!.id && $0.membershipStatus == .active }) == true {
                    return true
                } else {
                    return false
                }
            }
            .map { group in
                GroupCellViewModel(groupRepository: self.groupRepository, accountabilityGroup: group)
            }
        }
        .assign(to: \.activeGroupViewModels, on: self)
        .store(in: &cancellables)
    }
    
    func loadPendingGroups() {
        self.groupRepository.accountabilityGroupsPublisher.map { groups in
            groups.filter { group in
                if group.members?.contains(where: { $0.userId == self.currentUser.currentUser!.id && $0.membershipStatus == .pending }) == true {
                    return true
                } else {
                    return false
                }
            }
            .map { group in
                GroupCellViewModel(groupRepository: self.groupRepository, accountabilityGroup: group)
            }
        }
        .assign(to: \.pendingInviteViewModels, on: self)
        .store(in: &cancellables)
    }
    
    func acceptInvitationTo(_ accountabilityGroup: AccountabilityGroup) throws {
        let userProfile = currentUser.currentUser
        guard userProfile?.id != nil else {
            throw ErrorUpdatingUserMembership.userHasNoId
        }
        
        do {
            try updateGroupToActive(currentUser: userProfile!, accountabilityGroup: accountabilityGroup)
        } catch {
            throw error
        }

        do {
            try updateUserToActive(accountabilityGroup: accountabilityGroup)
        } catch {
            throw error
        }
    }
    
    private func updateGroupToActive(currentUser: UserProfile, accountabilityGroup: AccountabilityGroup) throws {
        var group = accountabilityGroup
        
        let index = group.members?.firstIndex(where: { $0.userId == currentUser.id })
        
        guard index != nil else {
            throw ErrorUpdatingGroupMembership.groupHasNoMember
        }
        
        let membershipStatus = group.members![index!].membershipStatus
        
        if membershipStatus == .pending {
            group.members![index!].membershipStatus = .active
        } else if membershipStatus == .active {
            throw ErrorUpdatingGroupMembership.updatesMatchCurrentMember
        } else {
            throw ErrorUpdatingGroupMembership.groupHasNoMember
        }
        
        self.groupRepository.updateGroup(group)
    }
    
    private func updateUserToActive(accountabilityGroup: AccountabilityGroup) throws {
        var user = self.currentUser.currentUser!
        
        let index = user.groupMembership?.firstIndex(where: { $0.groupId == accountabilityGroup.id && $0.membershipStatus == .pending })
        
        guard index != nil else {
            throw ErrorUpdatingUserMembership.userHasNoMembership
        }
        
        user.groupMembership![index!].membershipStatus = .active
        
        do {
            try self.currentUser.updateCurrentUserFromUser(user)
        } catch {
            throw error
        }
    }
}
