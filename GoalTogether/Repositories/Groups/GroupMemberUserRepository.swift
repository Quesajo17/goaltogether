//
//  GroupMemberUserRepository.swift
//  GoalTogether
//
//  Created by Charlie Page on 7/9/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase
import Combine

class GroupMemberUserRepository: ObservableObject, GroupUserStoreType {

    let db = Firestore.firestore()
    var listener: ListenerRegistration?
    
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
    
    func loadGroupMembers() -> AnyPublisher<Bool, Never> {
        Future { promise in
            guard self.groupId != nil else {
                return
            }
            
            // add in the listener and query here
            
            promise(.success(true))
        }
        .eraseToAnyPublisher()
    }
    
    func updateUserMemberships(userAndMemberships: (UserProfile, [GroupMembership])) throws {
        var editingUser = userAndMemberships.0
        
        guard editingUser.groupMembership != userAndMemberships.1 else {
            throw ErrorUpdatingUserMembership.updatesMatchCurrentUserMemberships
        }
        
        editingUser.groupMembership = userAndMemberships.1
        
        do {
            let _ = try db.collection("users").document(editingUser.id!).setData(from: editingUser)
        } catch {
            throw error
        }
        
    }
    
    
    func endListening() {
        // stub
    }
}
