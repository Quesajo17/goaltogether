//
//  UserSearchViewModel.swift
//  GoalTogether
//
//  Created by Charlie Page on 7/12/21.
//

import Foundation
import Combine

class UserSearchViewModel: ObservableObject {
    
    @Published var userSearchRepository: UserStoreType
    
    @Published var availableUsers: [UserCellViewModel] = [UserCellViewModel]()
    
    
    var selectedUser: UserProfile? = nil
    var saveCallback: (UserProfile) -> Void
    
    private var cancellables = Set<AnyCancellable>()
    
    init(userRepository: UserStoreType, saveCallback: @escaping (UserProfile) -> Void) {
        self.userSearchRepository = userRepository
        self.saveCallback = saveCallback
        
        loadUsers()
    }
    
    func loadUsers() {
        self.userSearchRepository.usersPublisher.map { users in
            users.map { user in
                UserCellViewModel(user: user)
            }
        }
        .assign(to: \.availableUsers, on: self)
        .store(in: &cancellables)
    }
    
    
    // Check out my Stack Overflow question on this! https://stackoverflow.com/questions/68341138/swiftui-and-mvvm-passing-data-from-a-child-views-viewmodel-to-a-parent-views
    func save(user: UserProfile) {
        self.saveCallback(user)
    }
}
