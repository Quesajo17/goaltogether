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
    @Published var pendingInviteViewModels: [SingleGroupViewModel] = [SingleGroupViewModel]()
    
    private var cancellables = Set<AnyCancellable>()
    
    
    init(groupRepository: GroupStoreType, currentUser: CurrentUserType = CurrentUserProfile.shared) {
        self.groupRepository = groupRepository
        self.currentUser = currentUser
        
        self.loadActiveGroups()
        self.loadPendingGroups()
    }
    
    func loadActiveGroups() {
        self.groupRepository.activeGroupsPublisher.map { groups in
            groups.map { group in
                GroupCellViewModel(groupRepository: self.groupRepository, accountabilityGroup: group)
            }
        }
        .assign(to: \.activeGroupViewModels, on: self)
        .store(in: &cancellables)
    }
    
    func loadPendingGroups() {
        self.groupRepository.pendingGroupsPublisher.map { groups in
            groups.map { group in
                SingleGroupViewModel(groupRepository: self.groupRepository, groupUserRepository: GroupMemberUserRepository(), group: group)
            }
        }
        .assign(to: \.pendingInviteViewModels, on: self)
        .store(in: &cancellables)
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
