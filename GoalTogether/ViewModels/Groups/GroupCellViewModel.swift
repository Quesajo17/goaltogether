//
//  GroupCellViewModel.swift
//  GoalTogether
//
//  Created by Charlie Page on 8/23/21.
//

import Foundation
import Combine

class GroupCellViewModel: ObservableObject, Identifiable {
    
    @Published var groupRepository: GroupStoreType
    
    @Published var group: AccountabilityGroup
    
    private var cancellables = Set<AnyCancellable>()
    
    init(groupRepository: GroupStoreType, currentUser: CurrentUserType = CurrentUserProfile.shared, accountabilityGroup: AccountabilityGroup) {
        self.groupRepository = groupRepository
        self.group = accountabilityGroup
    }
    
}
