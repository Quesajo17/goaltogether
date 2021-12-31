//
//  MyGroupsRepository.swift
//  GoalTogether
//
//  Created by Charlie Page on 7/6/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase

class MyGroupsRepository: ObservableObject, GroupStoreType {
    
    let db = Firestore.firestore()
    var activeListener: ListenerRegistration?
    var pendingListener: ListenerRegistration?
    
    @Published var activeGroups: [AccountabilityGroup] = [AccountabilityGroup]()
    var activeGroupsPublished: Published<[AccountabilityGroup]> { _activeGroups }
    var activeGroupsPublisher: Published<[AccountabilityGroup]>.Publisher { $activeGroups }

    @Published var pendingGroups: [AccountabilityGroup] = [AccountabilityGroup]()
    var pendingGroupsPublished: Published<[AccountabilityGroup]> { _pendingGroups }
    var pendingGroupsPublisher: Published<[AccountabilityGroup]>.Publisher { $pendingGroups }
    

    
    init() {
        self.activeGroupsListener()
        self.pendingGroupsListener()
    }
    
    
    func activeGroupsListener() {
        guard CurrentUserProfile.shared.currentUser?.id != nil else {
            fatalError("Loading User Groups while Current User id equals nil")
        }
        
        let userId = CurrentUserProfile.shared.currentUser?.id
        
        self.activeListener = db.collection("accountabilityGroup")
            .whereField("activeMembers", arrayContains: userId!)
            .addSnapshotListener { (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    self.activeGroups = querySnapshot.documents.compactMap {
                        document in
                        do {
                            let x = try document.data(as: AccountabilityGroup.self)
                            return x
                        }
                        catch {
                            print("An error loading the group has occurred")
                            print(error)
                        }
                        return nil
                    }
                }
            }
    }

    
    func pendingGroupsListener() {
        guard CurrentUserProfile.shared.currentUser?.id != nil else {
            fatalError("Loading User Groups while Current User id equals nil")
        }
        
        let userId = CurrentUserProfile.shared.currentUser?.id
        
        self.pendingListener = db.collection("accountabilityGroup")
            .whereField("pendingMembers", arrayContains: userId!)
            .addSnapshotListener { (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    self.pendingGroups = querySnapshot.documents.compactMap {
                        document in
                        do {
                            let x = try document.data(as: AccountabilityGroup.self)
                            return x
                        }
                        catch {
                            print("An error loading the group has occurred")
                            print(error)
                        }
                        return nil
                    }
                }
            }
    }


    private func getNewGroupId(_ accountabilityGroup: AccountabilityGroup) -> String {
        let groupId = db.collection("accountabilityGroup").document().documentID
        return groupId
    }
    
    func addGroup(_ accountabilityGroup: AccountabilityGroup) throws -> String {
        let id = getNewGroupId(accountabilityGroup)
        
        do {
            let _ = try db.collection("accountabilityGroup").document(id).setData(from: accountabilityGroup)
        } catch {
            print("Could not save the accountability group")
            throw UserProfileError.newOldIDMismatch
        }
        
        return id
    }
    
    func updateGroup(_ accountabilityGroup: AccountabilityGroup) {
        if let groupID = accountabilityGroup.id {
            do {
                try db.collection("accountabilityGroup").document(groupID)
                    .setData(from: accountabilityGroup)
            } catch {
                fatalError("Unable to encode action: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteGroup(_ accountabilityGroup: AccountabilityGroup) {
        // stub
    }
    
    func addUserToGroup(group: AccountabilityGroup, user: UserProfile) {
        // stub
    }
    
     func endListening() {
        // stub
    }
    
}
