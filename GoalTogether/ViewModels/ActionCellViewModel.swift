//
//  ActionCellViewModel.swift
//  GoalTogether
//
//  Created by Charlie Page on 4/3/21.
//

import Foundation
import Combine

class ActionCellViewModel: ObservableObject, Identifiable {
    @Published var actionRepository = ActionRepository()
    @Published var action: Action
    @Published var modified = false
    
    var id: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init(action: Action) {
        self.action = action
        
        $action
            .compactMap { action in
                action.id
            }
            .assign(to: \.id, on: self)
            .store(in: &cancellables)
        
        $action
            .dropFirst()
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .sink { [weak self] action in
                self?.modified = true
                self?.actionRepository.updateAction(action)
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
