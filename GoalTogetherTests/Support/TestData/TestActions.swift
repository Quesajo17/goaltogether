//
//  TestActions.swift
//  GoalTogetherTests
//
//  Created by Charlie Page on 4/3/21.
//

import Foundation
@testable import GoalTogether

class TestActions {
    var actionsCollection: [Action]
    
    init() {
        self.actionsCollection = [
            Action(title: "First test action, due today"),
            Action(title: "Second action to be modified"),
            Action(title: "Action from yesterday", startDate: Date().yesterdayAlmostMidnight()),
            Action(title: "Action for beginning of next week", startDate: Date().endOfWeekDate().tomorrowDate()),
            Action(title: "Action for the beginning of the second week", startDate: Date().endOfWeekDate().tomorrowDate().endOfWeekDate().tomorrowDate())
        ]
    }
}
