//
//  ActiveMemberActionCellViewModel.swift
//  GoalTogether
//
//  Created by Charlie Page on 9/22/21.
//

import Foundation
import Combine

class ActiveMemberActionCellViewModel: ObservableObject, Identifiable {
    
    @Published var action: Action
    
    init(action: Action) {
        self.action = action
    }
}
