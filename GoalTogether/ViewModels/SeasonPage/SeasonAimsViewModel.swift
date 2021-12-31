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
                return
            }
            
            guard seasonLength != oldValue else {
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
                return
            }

            self.aimRepository.season = featuredSeason
        }
    }
    
    @Published var inProgressAimCellViewModels = [MyAimCellViewModel]()
    @Published var completedAimCellViewModels = [MyAimCellViewModel]()
    
    @Published var aimCellViewModels = [MyAimCellViewModel]()
    
    @Published var currentUser: CurrentUserType
    
    private var cancellables = Set<AnyCancellable>()
    
    
    init(aimRepository: AimStoreType = MyAimsRepository(), seasonRepository: SeasonStoreType = SeasonRepository(),currentUser: CurrentUserType = CurrentUserProfile.shared) {
        self.aimRepository = aimRepository
        self.seasonRepository = seasonRepository
        self.currentUser = currentUser
        self.seasonLength = currentUser.currentUser?.seasonLength
        
        subscribeToCurrentSeason()
        // loadAims()
        loadInProgressAims()
        loadCompletedAims()
        
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
        
        
        // Sets the default season in the view model to default.
        self.defaultSeason = season
        self.featuredSeason = season
        guard seasonId != userProfileDefaultSeason else {
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
                MyAimCellViewModel(aimRepository: self.aimRepository, aim: aim, userProfile: self.currentUser.currentUser!)
            }
        }
        .assign(to: \.aimCellViewModels, on: self)
        .store(in: &cancellables)
    }
    
    func loadInProgressAims() {
        self.aimRepository.aimsPublisher.map { aims in
            aims.filter { aim in
                aim.completed == false
            }
            .map { aim in
                MyAimCellViewModel(aimRepository: self.aimRepository, aim: aim, userProfile: self.currentUser.currentUser!)
            }
        }
        .assign(to: \.inProgressAimCellViewModels, on: self)
        .store(in: &cancellables)
    }
    
    func loadCompletedAims() {
        self.aimRepository.aimsPublisher.map { aims in
            aims.filter { aim in
                aim.completed
            }
            .map { aim in
                MyAimCellViewModel(aimRepository: self.aimRepository, aim: aim, userProfile: self.currentUser.currentUser!)
            }
        }
        .assign(to: \.completedAimCellViewModels, on: self)
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
