//
//  TestGroups.swift
//  GoalTogetherTests
//
//  Created by Charlie Page on 7/8/21.
//

import Foundation
@testable import GoalTogether

class TestGroups {
    var groupsCollection: [AccountabilityGroup]
    
    init() {
        self.groupsCollection = [
            AccountabilityGroup(
                id: "acctgroup1",
                title: "Mastermind Group",
                description: "This is a mastermind group used for testing",
                creationDate: Date(),
                activeMembers: ["charliepage"],
                pendingMembers: ["giannis"]
            ),
            AccountabilityGroup(
                id: "acctgroup2",
                title: "Specialty Group",
                description: "This is a specialty group someone has been invited to.",
                creationDate: Date(),
                activeMembers: nil,
                pendingMembers: ["charliepage"]
            )
        ]
    }
}
