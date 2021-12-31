//
//  MyAimCellViewModel.swift
//  GoalTogether
//
//  Created by Charlie Page on 6/20/21.
//

import Foundation
import Combine


class MyAimCellViewModel: ObservableObject, Identifiable {
    
    @Published var aimRepository: AimStoreType
    @Published var aimActionRepository: ActionStoreType
    
    @Published var aim: Aim
    @Published var actions: [Action]?
    
    @Published var expandedView: Bool = false
    var detailsLoaded: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init(aimRepository: AimStoreType, aim: Aim, userProfile: UserProfile) {
        self.aimRepository = aimRepository
        self.aim = aim
        self.aimActionRepository = AimActionRepository(aim: aim, userProfile: userProfile)
        subscribeToAimActions()
    }
    
    
    init(aimRepository: AimStoreType, aim: Aim, aimActionRepository: ActionStoreType) {
        self.aimRepository = aimRepository
        self.aimActionRepository = aimActionRepository
        self.aim = aim
        subscribeToAimActions()
    }
    
    func subscribeToAimActions() {
        self.aimActionRepository.actionsPublisher
            .compactMap { $0 }
            .assign(to: \.actions, on: self)
            .store(in: &cancellables)
    }
    
    
    func loadAimDetails() {
        guard detailsLoaded != true else {
            return
        }
        
        self.aimActionRepository.loadData()
        detailsLoaded = true
    }
    
    func addAction(_ action: Action) {
        self.aimActionRepository.addAction(action)
    }
    
    func updateAction(_ action: Action) {
        self.aimActionRepository.updateAction(action)
    }
    
    func printActionCount() {
        print(self.actions?.count ?? "action count is nil")
    }
    
    func completeAim() {
        if self.aim.completed == false {
            self.aim.completed = true
            self.aim.completionDate = Date()
            self.aimRepository.updateAim(self.aim)
        } else {
            return
        }
    }
}
