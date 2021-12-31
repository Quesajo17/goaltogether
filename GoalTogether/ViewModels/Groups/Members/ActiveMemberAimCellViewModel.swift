//
//  ActiveMemberAimCellViewModel.swift
//  GoalTogether
//
//  Created by Charlie Page on 9/22/21.
//

import Foundation
import Combine


class ActiveMemberAimCellViewModel: ObservableObject, Identifiable {
    @Published var aimActionRepository: ActionStoreType
    
    @Published var aim: Aim
    @Published var actions: [Action]?
    
    @Published var expandedView: Bool = false
    private var detailsLoaded: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init(aim: Aim, userProfile: UserProfile) {
        self.aim = aim
        self.aimActionRepository = AimActionRepository(aim: aim, userProfile: userProfile)
        subscribeToAimActions()
    }
    
    
    init(aim: Aim, aimActionRepository: ActionStoreType) {
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
}
