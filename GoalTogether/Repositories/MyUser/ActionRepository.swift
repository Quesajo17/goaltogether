//
//  ActionRepository.swift
//  GoalTogether
//
//  Created by Charlie Page on 4/3/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase

class ActionRepository: ObservableObject, ActionStoreType {
    
    let db = Firestore.firestore()
    var listener: ListenerRegistration?
    
    @Published var actions = [Action]()
    var actionsPublished: Published<[Action]> { _actions }
    var actionsPublisher: Published<[Action]>.Publisher { $actions }
    

    
    init() {
        loadData()
    }
    
    func loadData() {
        let userId = Auth.auth().currentUser?.uid
        
        if userId != nil {
            self.listener = db.collection("action")
                .order(by: "startDate")
                .whereField("userId", isEqualTo: userId!)
                .whereField("completed", isEqualTo: false)
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
        } else {
            return
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
    
    func addActionWithAim(action: Action, aim: Aim) {
        var addedAction = action
        if aim.id != nil {
            addedAction.aimId = aim.id
        }
        addAction(addedAction)
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
