//
//  SeasonAimsViewModel.swift
//  GoalTogether
//
//  Created by Charlie Page on 5/18/21.
//

import Foundation
import Combine



class SeasonAimsViewModel: ObservableObject {
    @Published var aimRepository: AimStoreType
    @Published var seasonRepository: SeasonStoreType
    @Published var seasonLength: SeasonLength? {
        didSet {
            guard seasonLength != nil else {
                print("Season Length is nil - ending the SeasonLength didSet")
                return
            }
            
            guard seasonLength != oldValue else {
                print("Season Length was set to the same value.")
                return
            }
            
            do {
                try self.currentUser.updateCurrentUserItems(firstName: nil, lastName: nil, email: nil, phoneNumber: nil, birthday: nil, defaultSeason: nil, seasonLength: seasonLength, groupMembership: nil)
            } catch {
                print(error.localizedDescription)
            }
            
            guard self.defaultSeason == nil else {
                return
            }
            
            self.seasonRepository.loadOrCreateCurrentSeason()
        }
    }
    
    @Published var defaultSeason: Season?
    @Published var featuredSeason: Season? {
        didSet {
            guard featuredSeason != nil else {
                print("Trying to set GoalRepository based on featured Season. Featured Season is nil.")
                return
            }

            self.aimRepository.season = featuredSeason
        }
    }
    
    @Published var aimCellViewModels = [MyAimCellViewModel]()
    
    @Published var currentUser: CurrentUserType
    
    private var cancellables = Set<AnyCancellable>()
    
    
    init(aimRepository: AimStoreType = MyAimsRepository(), seasonRepository: SeasonStoreType = SeasonRepository(),currentUser: CurrentUserType = CurrentUserProfile.shared) {
        self.aimRepository = aimRepository
        self.seasonRepository = seasonRepository
        self.currentUser = currentUser
        self.seasonLength = currentUser.currentUser?.seasonLength
        
        subscribeToCurrentSeason()
        loadAims()
        
    }
    
    deinit {
        print("deinitializing the SeasonGoalsViewModel")
    }
}

// MARK: Extension for setting season updates and handling season updates.
extension SeasonAimsViewModel {
    func handleNewDefaultSeason(_ season: Season) {
        let seasonId = season.id
        let userProfileDefaultSeason = currentUser.currentUser?.defaultSeason
        
        print("season ID is equal to \(String(describing: seasonId))")
        print("userProfileDefaultSeasonId is equal to \(String(describing: userProfileDefaultSeason))")
        print("SeasonLength is \(String(describing: seasonLength))")
        
        
        // Sets the default season in the view model to default.
        self.defaultSeason = season
        self.featuredSeason = season
        guard seasonId != userProfileDefaultSeason else {
            print("Season ID of \(String(describing: seasonId)) is already equal to user profile default season: \(String(describing: userProfileDefaultSeason))")
            return
        }
        guard self.currentUser.currentUser != nil else {
            fatalError("there is no current user")
        }
        
        do {
            try self.currentUser.updateCurrentUserItems(firstName: nil, lastName: nil, email: nil, phoneNumber: nil, birthday: nil, defaultSeason: seasonId, seasonLength: nil, groupMembership: nil)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func subscribeToCurrentSeason() {
        self.seasonRepository.currentSeasonPublisher
            .dropFirst()
            .sink { [weak self] season in
                print("SeasonLength is \(String(describing: self?.seasonLength))")
                if season != nil {
                    self?.handleNewDefaultSeason(season!)
                }
            }
            .store(in: &cancellables)
    }
}


// MARK: Extension for loading and handling updates to the Aims list.
extension SeasonAimsViewModel {
    func loadAims() {
        self.aimRepository.aimsPublisher.map { aims in
            aims.map { aim in
                MyAimCellViewModel(aimRepository: self.aimRepository, aim: aim)
            }
        }
        .assign(to: \.aimCellViewModels, on: self)
        .store(in: &cancellables)
    }
    
    func addAim(_ aim: Aim) {
        self.aimRepository.addAim(aim)
    }
    
    func updateAim(_ aim: Aim) {
        self.aimRepository.updateAim(aim)
    }
}


/*
// MARK: Extension for erroring out when there is no aims repository
// This might be superfluous now.
enum AimError: Error {
    case noAimRepository
}

extension AimError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noAimRepository:
            return NSLocalizedString(
                "Could not find an Aim repository to update", comment: ""
            )
        }
    }
}
*/
