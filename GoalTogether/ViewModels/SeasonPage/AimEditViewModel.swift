//
//  AimEditViewModel.swift
//  GoalTogether
//
//  Created by Charlie Page on 6/28/21.
//

import Foundation
import Combine

class AimEditViewModel: ObservableObject, Identifiable {
    
    @Published var aimRepository: AimStoreType
    @Published var aim: Aim
    @Published var completionState: Bool
    
    private var cancellables = Set<AnyCancellable>()
    
    init(aimRepository: AimStoreType, aim: Aim) {
        self.aimRepository = aimRepository
        self.aim = aim
        self.completionState = aim.completed
        
        $completionState
            .sink { [weak self] completionState in
                self?.aim.completed = completionState
                if self?.aim.completed == true {
                    self?.aim.completionDate = Date()
                }
                self?.aimRepository.updateAim(self!.aim)
            }
            .store(in: &cancellables)
    }
    
    func addAim(aim: Aim) {
        aimRepository.addAim(aim)
    }
    
    func updateAim(aim: Aim) {
        aimRepository.updateAim(aim)
    }
}
