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
    
    @Published var actions = [Action]()
    var actionsPublished: Published<[Action]> { _actions }
    var actionsPublisher: Published<[Action]>.Publisher { $actions }
    

    
    init() {
        loadData()
    }
    
    func loadData() {
        let userId = Auth.auth().currentUser?.uid
        
        if userId != nil {
            db.collection("action")
                .order(by: "createdTime")
                .whereField("userId", isEqualTo: userId!)
                .addSnapshotListener { (querySnapshot, error) in
                    if let querySnapshot = querySnapshot {
                        self.actions = querySnapshot.documents.compactMap { document in
                            do {
                                let x = try document.data(as: Action.self)
                                return x
                            }
                            catch {
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
    
    /*func loadMyDataByDate(look frontBack: Bool, from baseDate: Date, until secondaryDate: Date? = nil) {
        let userId = Auth.auth().currentUser?.uid
        
     I need to look at adding an enumeration for forward/backward to do this version of it. And then I'll mess around with that.
     
    }*/
    
    func loadMyDataByDate2(from startDate: Date, to endDate: Date? = nil) {
        let userId = Auth.auth().currentUser?.uid
        let initialDate = startDate
        var finalDate: Date
        
        if endDate == nil {
            finalDate = Calendar.current.date(byAdding: .day, value: 1, to: initialDate)!
        } else {
            finalDate = endDate!
        }
        
        
        db.collection("action")
            .order(by: "createdTime")
            .whereField("userId", isEqualTo: userId!)
            .whereField("startDate", isGreaterThanOrEqualTo: initialDate)
            .whereField("startDate", isLessThanOrEqualTo: finalDate)
            .addSnapshotListener { (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    self.actions = querySnapshot.documents.compactMap { document in
                        do {
                            let x = try document.data(as: Action.self)
                            return x
                        }
                        catch {
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
            do {
                try db.collection("action").document(actionID).delete()
            }
            catch {
                fatalError("Unable to delete action: \(error.localizedDescription)")
            }
        }
    }
    
    func endListening() {
        
    }
    
}
