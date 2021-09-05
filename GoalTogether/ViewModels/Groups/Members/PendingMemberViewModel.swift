//
//  PendingMemberViewModel.swift
//  GoalTogether
//
//  Created by Charlie Page on 7/23/21.
//

import Foundation
import Combine

class PendingMemberViewModel: ObservableObject {
    var user: UserProfile
    
    init(user: UserProfile) {
        self.user = user
    }
}
