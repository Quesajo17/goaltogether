//
//  MockSeasonRepository.swift
//  GoalTogetherTests
//
//  Created by Charlie Page on 5/22/21.
//

import Foundation
@testable import GoalTogether
import Combine

class MockSeasonRepository: ObservableObject, SeasonStoreType {

    var userProfile: UserProfile
    var db: [Season]
    
    @Published var currentSeason: Season? = nil
    var currentSeasonPublished: Published<Season?> { _currentSeason }
    var currentSeasonPublisher: Published<Season?>.Publisher { $currentSeason }
    
    @Published var seasonList: [Season] = [Season]()
    var seasonListPublished: Published<[Season]> { _seasonList }
    var seasonListPublisher: Published<[Season]>.Publisher { $seasonList }
    
    private var cancellables = Set<AnyCancellable>()
    
    init(testProfiles: CurrentUserType, db: [Season]) {
        self.userProfile = testProfiles.currentUser!
        self.db = db
    }
    
    func readyForSeason() {
        
    }
    
    // Need to make this function longer in order to have it determine based on the quarterly value that was selected, what to do.

    
    
    
    func loadOrCreateCurrentSeason() {
        var _ = loadMostRecentSeason()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                    self.loadOrCreateSeasonFromTimeSearch()
                }
            }, receiveValue: { [weak self] season in
                if season.endDate < Date() {
                    self?.loadOrCreateSeasonFromTimeSearch()
                } else {
                    self?.currentSeason = season
                }
            })
    }
    
    private func loadOrCreateSeasonFromTimeSearch() {
        var _ = loadPrimaryUserSeason()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                    self.currentSeason = self.createAddAndSetDefault()
                }
            }, receiveValue: { [weak self] season in
                if season.endDate < Date() {
                    let oldOrder = season.order
                    self?.currentSeason = self?.createAddAndSetDefault(order: oldOrder)
                } else {
                    self?.currentSeason = season
                }
            })
    }
    
    
    
    private func loadPrimaryUserSeason() -> Future<Season, ErrorLoadingSeason> {
        let seasons = db
        let profileSeasonID = userProfile.defaultSeason
        
        return Future<Season, ErrorLoadingSeason> { promise in
            
            if profileSeasonID == nil {
                promise(Result.failure(ErrorLoadingSeason.NoDefaultUserSeason))
            } else if let i = seasons.firstIndex(where: { $0.id == profileSeasonID }) {
                let season = seasons[i]
                promise(Result.success(season))
            } else {
                promise(Result.failure(ErrorLoadingSeason.DefaultUserSeasonNotFound))
            }
        }
    }
    
    func loadMostRecentSeason() -> Future<Season, ErrorLoadingSeason> {
        let seasons = db
        
        return Future<Season, ErrorLoadingSeason> { promise in
            // Can't use max with this array. Is it an array? Why isn't it working?
            
            if let mostRecentSeason = seasons.max(by: { $0.order < $1.order }) {
                promise(Result.success(mostRecentSeason))
            } else {
                promise(Result.failure(ErrorLoadingSeason.NoSeasonFound))
            }
        }
    }
    
    private func createAddAndSetDefault(order: Int = 0) -> Season {
        let season = createCurrentSeason(order: order)
        addSeasonToArray(season)
        return season
    }
    
    private func createCurrentSeason(order: Int = 0) -> Season {
        let id = "newSeasonID"
        
        return Season(userProfile: userProfile, referenceDate: Date(), lastOrder: order, id: id)
    }
    
    private func addSeasonToArray(_ season: Season) {
        seasonList.append(season)
    }
}
