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
    var listener: ListenerRegistration?
    
    @Published var accountabilityGroups = [AccountabilityGroup]()
    var accountabilityGroupsPublished: Published<[AccountabilityGroup]> { _accountabilityGroups }
    var accountabilityGroupsPublisher: Published<[AccountabilityGroup]>.Publisher { $accountabilityGroups }
    
    init() {
        self.myGroupsListener()
    }
    
    
    func myGroupsListener() {
        guard CurrentUserProfile.shared.currentUser?.id != nil else {
            fatalError("Loading User Groups while Current User id equals nil")
        }
        
        let userId = CurrentUserProfile.shared.currentUser?.id
        
        self.listener = db.collection("accountabilityGroup")
            .whereField("members", arrayContains: userId!)
            .addSnapshotListener { (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    self.accountabilityGroups = querySnapshot.documents.compactMap {
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
        // stub
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
