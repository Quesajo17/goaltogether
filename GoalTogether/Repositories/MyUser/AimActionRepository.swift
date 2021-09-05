//
//  AimActionRepository.swift
//  GoalTogether
//
//  Created by Charlie Page on 6/29/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase
import Combine

class AimActionRepository: ObservableObject, AimActionStoreType {
    
    let db = Firestore.firestore()
    var listener: ListenerRegistration?
    
    var aim: Aim
    
    @Published var actions: [Action] = [Action]()
    var actionsPublished: Published<[Action]> { _actions }
    var actionsPublisher: Published<[Action]>.Publisher { $actions }
    
    required init(aim: Aim) {
        self.aim = aim
    }
    
    func loadData() {
        let userId = CurrentUserProfile.shared.currentUser!.id
        let aimId = self.aim.id
        
        guard aimId != nil else {
            print("Cannot load actions associated with \(aim.title) - ID is nil")
            return
        }
        
        guard userId != nil else {
            print("Cannot load actions for this aim - User ID (in the current user) is nil.")
            return
        }
        
        db.collection("action")
            .order(by: "startDate")
            .whereField("userId", isEqualTo: userId!)
            .whereField("aimId", isEqualTo: aimId!)
            .addSnapshotListener { (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    self.actions = querySnapshot.documents.compactMap { document in
                        do {
                            let x = try document.data(as: Action.self)
                            return x
                        }
                        catch {
                            print("An error has occurred")
                            print(error)
                        }
                        return nil
                    }
                }
            }
    }
    
    func addAction(_ action: Action) {
        do {
            var addedAction = action
            addedAction.userId = Auth.auth().currentUser?.uid
            let _ = try db.collection("action").addDocument(from: addedAction)
        }
        catch {
            fatalError("Unable to encode action: \(error.localizedDescription)")
        }
    }
    
    func updateAction(_ action: Action) {
        if let actionID = action.id {
            do {
                try db.collection("action").document(actionID).setData(from: action)
            }
            catch {
                fatalError("Unable to encode action: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteAction(_ action: Action) {
        if let actionID = action.id {
            db.collection("action").document(actionID).delete()
        }
    }
    
    func endListening() {
        listener!.remove()
    }
    
    
}
