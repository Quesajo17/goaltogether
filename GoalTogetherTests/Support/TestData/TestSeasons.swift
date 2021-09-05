//
//  TestSeasons.swift
//  GoalTogetherTests
//
//  Created by Charlie Page on 5/22/21.
//

import Foundation
@testable import GoalTogether

class TestSeasons {
    var seasonsCollectionQuarterlyNoCurrent: [Season]
    var seasonsCollectionMonthlyCurrent: [Season]
    var seasonsCollectionBlank = [Season]()
    
    var testProfiles = TestUserProfile()
    
    /*
     ID Notation for the test seasons:
     q or m: dates for quarters or months?
     NC or C: No Current or Current - does this data set have an instance for the current quarter or month?
     X qs/ms ago (e.g. 3qsAgo): How many months or quarters ago is that particular season for?
        If it's for the current quarter or month, it will say "ThisQ" or "ThisM"
     */
    init() {
        self.seasonsCollectionQuarterlyNoCurrent = [
            Season(userProfile: testProfiles.userProfile,
                   referenceDate: Date().minusQuarters(3),
                   lastOrder: 0, id: "qNC3qsAgo"),
            Season(userProfile: testProfiles.userProfile,
                   referenceDate: Date().minusQuarters(2),
                   lastOrder: 1, id: "qNC2qsAgo"),
            Season(userProfile: testProfiles.userProfile,
                   referenceDate: Date().minusQuarters(1),
                   lastOrder: 2, id: "qNC2qsAgo")
        ]
        
        self.seasonsCollectionMonthlyCurrent = [
            Season(userProfile: testProfiles.userProfile,
                   referenceDate: Date().minusMonths(3),
                   lastOrder: 0, id: "mC3msAgo"),
            Season(userProfile: testProfiles.userProfile,
                   referenceDate: Date().minusMonths(2),
                   lastOrder: 1, id: "mC2msAgo"),
            Season(userProfile: testProfiles.userProfile,
                   referenceDate: Date().minusMonths(1),
                   lastOrder: 2, id: "mC1mAgo"),
            Season(userProfile: testProfiles.userProfile,
                   referenceDate: Date(),
                   lastOrder: 3, id: "mCThisM")
        ]
    }
}

private extension Date {
    func minusQuarters(_ quarters: Int) -> Date {
        let referenceDate = self
        let months = quarters * 3
        
        var components = Calendar.current.dateComponents([.year, .month, .day], from: referenceDate)
        components.month = (components.month ?? 0) - months
        let newDate = Calendar.current.date(from: components)!
        
        return newDate
    }
    
    func minusMonths(_ months: Int) -> Date {
        let referenceDate = self
        
        var components = Calendar.current.dateComponents([.year, .month, .day], from: referenceDate)
        components.month = (components.month ?? 0) - months
        let newDate = Calendar.current.date(from: components)!
        
        return newDate
    }
}
