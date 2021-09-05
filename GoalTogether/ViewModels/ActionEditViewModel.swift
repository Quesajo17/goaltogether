//
//  ActionEditViewModel.swift
//  GoalTogether
//
//  Created by Charlie Page on 5/11/21.
//

import Foundation
import Combine

class ActionEditViewModel: ObservableObject, Identifiable {
    
    @Published var actionRepository: ActionStoreType
    @Published var action: Action
    @Published var completionState: Bool
    
    private var cancellables = Set<AnyCancellable>()
    
    init(actionRepository: ActionStoreType, action: Action) {
        self.actionRepository = actionRepository
        self.action = action
        self.completionState = action.completed
        
        $completionState
            .sink { [weak self] completionState in
                self?.action.completed = completionState
                if self?.action.completed == true {
                    self?.action.completionDate = Date()
                }
                self?.actionRepository.updateAction(self!.action)
            }
            .store(in: &cancellables)
    }
    
    func addAction(action: Action) {
        actionRepository.addAction(action)
    }
    
    func updateAction(action: Action) {
        actionRepository.updateAction(action)
    }
}
