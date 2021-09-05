//
//  TestGoals.swift
//  GoalTogetherTests
//
//  Created by Charlie Page on 5/19/21.
//

import Foundation
@testable import GoalTogether

class TestAims {
    var aimsCollection: [Aim]
    var season: Season
    
    init(season: Season) {
        self.season = season
        
        self.aimsCollection = [
         Aim(id: "Goal1",
              title: "First goal, containing first and second test action",
              userId: "charliepage",
              seasonId: "newSeasonID",
              startDate: Date(),
              plannedEndDate: season.endDate,
              completed: false,
              completionDate: nil,
              description: "Here's a test description for this goal.",
              actions: nil
              ),
            Aim(id: "Goal2",
                 title: "Second goal, containing no test actions.",
                 userId: "charliepage",
                 seasonId: "newSeasonID",
                 startDate: Date(),
                 plannedEndDate: season.endDate,
                 completed: false,
                 completionDate: nil,
                 description: nil,
                 actions: nil
                 ),
            Aim(id: "Goal3",
                 title: "Third goal, already completed.",
                 userId: "charliepage",
                 seasonId: "newSeasonID",
                 startDate: Date(),
                 plannedEndDate: season.endDate,
                 completed: false,
                 completionDate: nil,
                 description: "This goal is already completed",
                 actions: nil
                 ),
            Aim(id: "Goal0Old",
                 title: "Fourth Goal, from last Quarter",
                 userId: "charliepage",
                 seasonId: "qNC2qsAgo",
                 startDate: Date(),
                 plannedEndDate: season.endDate,
                 completed: false,
                 completionDate: nil,
                 description: "This goal is already completed",
                 actions: nil
                 ),
        ]
    }
}
