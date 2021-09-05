//
//  AimActionEditViewModel.swift
//  GoalTogether
//
//  Created by Charlie Page on 7/5/21.
//

/*
import Foundation
import Combine

class AimActionEditViewModel: ObservableObject, Identifiable {
    
    @Published var aimActionRepository: AimActionStoreType
    @Published var action: Action
    @Published var completionState: Bool
    
    private var cancellables = Set<AnyCancellable>()
    
    init(action: Action) {
        self.action = action
        self.completionState = action.completed
        
        $completionState
            .sink { [weak self] completionState in
                self?.action.completed = completionState
                if self?.action.completed == true {
                    self?.action.completionDate = Date()
                }
                self?.aimActionRepository.updateAction(self!.action)
            }
            .store(in: &cancellables)
    }
    
    func addAction(action: Action) {
        aimActionRepository.addAction(action)
    }
    
    func updateAction(action: Action) {
        aimActionRepository.updateAction(action)
    }
}
*/
