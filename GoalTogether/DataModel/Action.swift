//
//  Action.swift
//  GoalTogether
//
//  Created by Charlie Page on 4/3/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Action: Codable, Identifiable {
    @DocumentID var id: String?
    var title: String
    var userId: String?
    var completed: Bool
    @ServerTimestamp var createdTime: Timestamp?
    var startDate: Date
    var dueDate: Date?
    var description: String?
    
    
    init(title: String) {
        self.title = title
        self.completed = false
        self.startDate = Date()
    }
    
    init(title: String, startDate: Date) {
        self.title = title
        self.completed = false
        self.startDate = startDate
    }
    
}

extension Action {
    func inDateRange (from firstDate: Date, to secondDate: Date) -> Bool {
        let referenceDate: Date = self.startDate
        
        
        let firstDateStart = Calendar.current.startOfDay(for: firstDate)
        let secondDateEnd = secondDate.tomorrowDate().yesterdayAlmostMidnight()
        
        guard firstDateStart < secondDateEnd else {
            print("First date start of \(firstDateStart) is after second date of \(secondDateEnd)")
            return false
        }
        
        let range = firstDateStart...secondDateEnd
        
        if range.contains(referenceDate) {
            return true
        } else {
            return false
        }
    }
    
    func beforeDate(_ toDate: Date) -> Bool {
        let referenceDate: Date = self.startDate
        
        let rangeEnd = toDate.yesterdayAlmostMidnight()
        
        let range = ...rangeEnd
        
        if range.contains(referenceDate) {
            return true
        } else {
            return false
        }
    }
    
    func afterDate(_ afterDate: Date) -> Bool {
        let referenceDate: Date = self.startDate
        let afterDateStart = afterDate.tomorrowDate()
        
        let range = afterDateStart...
        
        if range.contains(referenceDate) {
            return true
        } else {
            return false
        }
    }
    
    func showIfIncomplete(onlyIncomplete hideComplete: Bool = true) -> Bool {
        let completionStatus: Bool = self.completed
        
        if hideComplete == false || completionStatus == false {
            return true
        } else {
            return false
        }
    }
}

