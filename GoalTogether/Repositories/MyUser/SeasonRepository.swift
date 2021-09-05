//
//  SeasonRepository.swift
//  GoalTogether
//
//  Created by Charlie Page on 5/24/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase
import Combine



class SeasonRepository: ObservableObject, SeasonStoreType {
    
    let db = Firestore.firestore()
    
    // I really ought to change this to just be the current user profile shared. No reason I should initialize it as anything else outside of my mock.
    var currentUser: CurrentUserType
    
    @Published var currentSeason: Season?
    var currentSeasonPublished: Published<Season?> { _currentSeason }
    var currentSeasonPublisher: Published<Season?>.Publisher { $currentSeason }
    
    @Published var seasonList = [Season]()
    var seasonListPublished: Published<[Season]> { _seasonList }
    var seasonListPublisher: Published<[Season]>.Publisher { $seasonList }
    
    private var cancellables = Set<AnyCancellable>()
    
    init(currentUser: CurrentUserType = CurrentUserProfile.shared) {
        self.currentUser = currentUser
    }
    
    /// The loadMostRecentSeason() function is probably a private function that loads the most recent season in the particular user's season subcollection.
    func loadMostRecentSeason() -> Future<Season, ErrorLoadingSeason> {
        let seasonRef = db.collection("users").document(currentUser.currentUser!.id!).collection("season")
        
        return Future<Season, ErrorLoadingSeason> { promise in
            seasonRef.order(by: "order", descending: true)
                .limit(to: 1)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting most recent season: \(err.localizedDescription)")
                        promise(Result.failure(ErrorLoadingSeason.NoSeasonFound))
                    } else {
                        if ((querySnapshot?.isEmpty) != false)  {
                            promise(Result.failure(ErrorLoadingSeason.NoSeasonFound))
                        } else {
                            for document in querySnapshot!.documents {
                                do {
                                    print("Document Data: \(String(describing: document))")
                                    let x = try document.data(as: Season.self)
                                    if x != nil {
                                        print("X equals \(String(describing: x))")
                                        promise(Result.success(x!))
                                    } else {
                                        promise(Result.failure(ErrorLoadingSeason.NoSeasonFound))
                                    }
                                } catch {
                                    print("An error converting the most recent season")
                                    print(error)
                                    promise(Result.failure(ErrorLoadingSeason.couldNotConvertData))
                                }
                            }
                        }
                    }
                }
        }
    }
    
    
    func loadOrCreateCurrentSeason() {
        var _ = loadMostRecentSeason()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                    self.addSeasonToSubcollection(season: Season(lastOrder: 0))
                }
            }, receiveValue: { season in
                    if season.endDate < Date() {
                        let oldOrder = season.order
                        self.currentSeason = self.createCurrentSeason(order: oldOrder)
                        self.addSeasonToSubcollection(season: Season(lastOrder: oldOrder))
                    } else {
                        self.currentSeason = season
                    }
                })
            .store(in: &cancellables)
    }
    
    private func createCurrentSeason(order: Int = 0) -> Season {
        return Season(lastOrder: order)
    }
    
    private func saveCurrentSeasonToPast() {
        
    }
    
    func addSeasonToSubcollection(season: Season) {
        let seasonCollectionRef = db.collection("users").document(currentUser.currentUser!.id!).collection("season")
        print("User Profile ID is \(currentUser.currentUser!.id!)")
        let newSeasonRef = seasonCollectionRef.document()
        
        var currentSeason = season
        currentSeason.id = newSeasonRef.documentID
        
        do {
            let _ = try newSeasonRef.setData(from: season)
        } catch {
            print("Could not set the document")
            return
        }
        
        do {
            try self.currentUser.updateCurrentUserItems(firstName: nil, lastName: nil, email: nil, phoneNumber: nil, birthday: nil, defaultSeason: newSeasonRef.documentID, seasonLength: nil, groupMembership: nil)
        } catch {
            print(error.localizedDescription)
            return
        }
        
        self.currentSeason = currentSeason
    }
    
    func loadAllSeasons() {
        
    }
}
