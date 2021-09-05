//
//  MockUserSearchRepository.swift
//  GoalTogetherTests
//
//  Created by Charlie Page on 7/19/21.
//

import Foundation
import Combine
@testable import GoalTogether

class MockUserSearchRepository: ObservableObject, UserStoreType {
    
    var db = TestUserProfile().allProfiles
    
    @Published var users: [UserProfile] = [UserProfile]()
    var usersPublished: Published<[UserProfile]> { _users }
    var usersPublisher: Published<[UserProfile]>.Publisher { $users }
    
    init() {
        loadUsers()
    }
    
    func loadUsers() {
        self.users = db
    }
    
    func endListening() {
        // stub
    }
}
