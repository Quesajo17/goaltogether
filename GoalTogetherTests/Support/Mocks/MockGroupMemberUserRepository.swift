//
//  MockGroupMemberUserRepository.swift
//  GoalTogetherTests
//
//  Created by Charlie Page on 7/9/21.
//

import Foundation
import Combine
@testable import GoalTogether

class MockGroupMemberUserRepository: ObservableObject, GroupUserStoreType {

    @Published var db = TestUserProfile.shared
    
    @Published var membersWithStatus: [(UserProfile, GroupMembershipStatus)] = [(UserProfile, GroupMembershipStatus)]()
    var membersWithStatusPublished: Published<[(UserProfile, GroupMembershipStatus)]> { _membersWithStatus }
    var membersWithStatusPublisher: Published<[(UserProfile, GroupMembershipStatus)]>.Publisher { $membersWithStatus }
    
    var groupId: String? {
        didSet {
            if groupId != nil && groupId != oldValue {
                let _ = self.loadGroupMembers()
            }
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        
    }
    
    internal func loadUsers() {
        // Stub
    }
    
    func loadByGroupId(groupId: String) {
        // stub
    }
    
    func loadGroupMembers() -> AnyPublisher<Bool, Never> {
        Future { promise in
            guard self.groupId != nil else {
                return
            }
            
            self.db.$allProfiles
                .print()
                .map { userProfiles in
                userProfiles.filter { userProfile in
                    if userProfile.groupMembership?.contains(where: { $0.groupId == self.groupId }) == true {
                        return true
                    } else {
                        return false
                    }
                }
                .map { userProfile in
                    let groupMembership = userProfile.groupMembership!.first(where: { $0.groupId == self.groupId })
                    
                    return (userProfile, groupMembership!.membershipStatus)
                    }
                }
                .assign(to: \.membersWithStatus, on: self)
                .store(in: &self.cancellables)
            promise(.success(true))
        }
        .eraseToAnyPublisher()
    }
    
    func inviteToGroup() {
        // stub
    }
    
    func updateUserMemberships(userAndMemberships: (UserProfile, [GroupMembership])) throws {
        var editingUser = userAndMemberships.0
        
        guard editingUser.groupMembership != userAndMemberships.1 else {
            throw ErrorUpdatingUserMembership.updatesMatchCurrentUserMemberships
        }
        
        editingUser.groupMembership = userAndMemberships.1
        
        let index = db.allProfiles.firstIndex(where: { $0.id == editingUser.id && $0.id != nil })
        
        guard index != nil else {
            throw UserProfileError.noUserProfileToUpdate
        }
        
        db.allProfiles[index!] = editingUser
    }
    
    func endListening() {
        // stub
    }
}
