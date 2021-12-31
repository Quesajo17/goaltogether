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
    var activeListener: ListenerRegistration?
    var pendingListener: ListenerRegistration?
    
    @Published var membersWithStatus: [(UserProfile, GroupMembershipStatus)] = [(UserProfile, GroupMembershipStatus)]()
    var membersWithStatusPublished: Published<[(UserProfile, GroupMembershipStatus)]> { _membersWithStatus }
    var membersWithStatusPublisher: Published<[(UserProfile, GroupMembershipStatus)]>.Publisher { $membersWithStatus }
    
    
    var group: AccountabilityGroup? {
        didSet {
            if group != nil && group != oldValue {
                let _ = self.loadGroupMembers()
            }
        }
    }
    
    func loadGroupMembers() -> AnyPublisher<Bool, Never> {
        Future { promise in
            guard self.group != nil else {
                return
            }
            
            guard self.group!.id != nil else {
                return
            }
            
            self.activeListener = self.db.collection("users")
                .whereField("groupMembership", arrayContains: [
                    "groupId": self.group!.id!,
                    "groupName": self.group!.title,
                    "membershipStatus": "active",
                                ])
                .addSnapshotListener { (querySnapshot, error) in
                    if let querySnapshot = querySnapshot {
                        self.membersWithStatus = querySnapshot.documents.compactMap {
                            document in
                            do {
                                let x = try document.data(as: UserProfile.self)
                                return (x!, GroupMembershipStatus.active)
                            } catch {
                                print(error)
                            }
                            return nil
                        }
                    }
                }
            
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
