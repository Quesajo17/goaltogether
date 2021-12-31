//
//  FriendAimAndActionRepository.swift
//  GoalTogether
//
//  Created by Charlie Page on 9/17/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase
import Combine

class FriendAimAndActionRepository: ObservableObject, AimAndActionStoreType {
    
    let db = Firestore.firestore()
    
    var user: UserProfile
    
    var startDate: Date
    var endDate: Date
    
    @Published var actions: [Action] = [Action]()
    var actionsPublished: Published<[Action]> { _actions }
    var actionsPublisher: Published<[Action]>.Publisher { $actions }
    
    @Published var aims: [Aim] = [Aim]()
    var aimsPublished: Published<[Aim]> { _aims }
    var aimsPublisher: Published<[Aim]>.Publisher { $aims }
    
    @Published var seasonTitle: String?
    var seasonTitlePublished: Published<String?> { _seasonTitle }
    var seasonTitlePublisher: Published<String?>.Publisher { $seasonTitle }
    
    private var cancellables = Set<AnyCancellable>()
    
    init(user: UserProfile) {
        self.user = user
        self.startDate = Date().startOfWeekDate()
        self.endDate = Date().endOfWeekDate()
        
        do {
            try loadActions()
            try loadAims()
        } catch {
            print(error)
        }
    }
    
    init(user: UserProfile, start: Date, end: Date) {
        self.user = user
        self.startDate = start
        self.endDate = end
        
        do {
            try loadActions()
            try loadAims()
        } catch {
            print(error)
        }
    }
    
    func loadActions() throws {
        guard user.id != nil else {
            throw ErrorLoadingFriendInfo.userHasNoId
        }
        
        db.collection("action")
            .whereField("userId", isEqualTo: user.id!)
            .whereField("referenceDate", isGreaterThanOrEqualTo: startDate)
            .whereField("referenceDate", isLessThanOrEqualTo: endDate)
            .getDocuments() { (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    self.actions = querySnapshot.documents.compactMap { document in
                        do {
                            let x = try document.data(as: Action.self)
                            return x
                        } catch {
                            print("An error has occurred")
                            print(error)
                    }
                    return nil
                }
            }
        }
    }
    
    func loadAims() throws {
        guard user.id != nil else {
            throw ErrorLoadingFriendInfo.userHasNoId
        }
        
        guard user.defaultSeason != nil else {
            throw ErrorLoadingFriendInfo.noDefaultSeason
        }
        
        db.collection("aim")
            .whereField("userId", isEqualTo: user.id!)
            .whereField("seasonId", isEqualTo: user.defaultSeason!)
            .getDocuments() { (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    self.aims = querySnapshot.documents.compactMap { document in
                        do {
                            let x = try document.data(as: Aim.self)
                            return x
                        } catch {
                            print("An error has occurred")
                            print(error)
                        }
                        return nil
                    }
                }
        }
    }
    
    func loadSeasonTitle() {
        let seasonId = user.defaultSeason
        
        guard seasonId != nil else {
            print(ErrorLoadingSeason.DefaultUserSeasonNotFound)
            return
        }
        
        let seasonRef = db.collection("users").document(user.id!).collection("season").document(seasonId!)
        
        let promise = getSeasonDocument(docRef: seasonRef)
        
        promise.sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                print(error)
            case .finished:
                break
            }
        }, receiveValue: { value in
            self.seasonTitle = value
        })
        .store(in: &cancellables)
    }
    
    
    private func getSeasonDocument(docRef: DocumentReference) -> Future<String, ErrorLoadingSeason> {
        
        return Future<String, ErrorLoadingSeason> { [weak self] promise in
            docRef.getDocument { (document, err) in
                if let document = document, document.exists {
                    let data = document.data()
                    let dataString = data!["title"] as? String ?? ""
                    if dataString != "" {
                        promise(.success(dataString))
                    } else {
                        promise(.failure(ErrorLoadingSeason.NoSeasonFound))
                    }
                } else if let err = err {
                    print("Error getting most recent season: \(err.localizedDescription)")
                    promise(.failure(ErrorLoadingSeason.NoSeasonFound))
                }
            }
        }
    }
}
