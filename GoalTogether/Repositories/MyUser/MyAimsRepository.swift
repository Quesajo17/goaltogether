//
//  GoalRepository.swift
//  GoalTogether
//
//  Created by Charlie Page on 5/22/21.
//


import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase

class MyAimsRepository: ObservableObject, AimStoreType {

    
    
    var season: Season? {
        didSet {
            guard season != nil else {
                return
            }
            
            guard aims.count == 0 else {
                print("Data already loaded. Skipping")
                return
            }
            
            loadData()
        }
    }
    
    let db = Firestore.firestore()
    var listener: ListenerRegistration?
    
    @Published var aims = [Aim]()
    var aimsPublished: Published<[Aim]> { _aims }
    var aimsPublisher: Published<[Aim]>.Publisher { $aims }
    
    
    func loadData() {
        let userId = AuthenticationState.shared.loggedInUser?.uid
        let seasonId = season?.id
        
        guard userId != nil && seasonId != nil else {
            return
        }
        
        self.listener = db.collection("aim")
            .order(by: "startDate")
            .whereField("userId", isEqualTo: userId!)
            .whereField("seasonId", isEqualTo: seasonId!)
            .addSnapshotListener { (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    self.aims = querySnapshot.documents.compactMap {
                        document in
                        do {
                            let x = try document.data(as: Aim.self)
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
    
    func loadDetails(_ aim: Aim) {
        // Stubs
    }
    
    func addAim(_ aim: Aim) {
        do {
            var addedAim = aim
            addedAim.userId = Auth.auth().currentUser?.uid
            let _ = try db.collection("aim").addDocument(from: addedAim)
        }
        catch {
            fatalError("Unable to encode aim: \(error.localizedDescription)")
        }
    }
    
    func updateAim(_ aim: Aim) {
        if let aimID = aim.id {
            do {
                try db.collection("aim").document(aimID).setData(from: aim)
            }
            catch {
                fatalError("Unable to encode aim: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteAim(_ aim: Aim) {
        // Stubs
    }
    
    func endListening() {
        // Stubs
    }
    
    
}


