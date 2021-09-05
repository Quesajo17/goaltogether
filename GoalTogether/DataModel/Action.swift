//
//  Action.swift
//  GoalTogether
//
//  Created by Charlie Page on 4/3/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Action: Codable, Identifiable, Equatable {
    @DocumentID var id: String?
    var title: String
    
    var userId: String?
    var aimId: String?
    
    var completed: Bool
    var completionDate: Date?
    @ServerTimestamp var createdTime: Timestamp?
    var startDate: Date
    var dueDate: Date?
    var description: String?
    var referenceDate: Date {
        get {
            if completed == true && completionDate != nil {
                return completionDate!
            } else {
                return startDate
            }
        }
    }
    
    
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
    
    init(title: String, aimId: String) {
        self.title = title
        self.completed = false
        self.startDate = Date()
        self.aimId = aimId
    }
    
}

extension Action {
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case userId
        case aimId
        
        case completed
        case completionDate
        case createdTime
        case startDate
        case dueDate
        case description
        case referenceDate
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decode(DocumentID<String>.self, forKey: .id)
        title = try values.decode(String.self, forKey: .title)
        userId = try values.decodeIfPresent(String.self, forKey: .userId)
        aimId = try values.decodeIfPresent(String.self, forKey: .aimId)
        completed = try values.decode(Bool.self, forKey: .completed)
        completionDate = try values.decodeIfPresent(Date.self, forKey: .completionDate)
        _createdTime = try values.decode(ServerTimestamp<Timestamp>.self, forKey: .createdTime)
        startDate = try values.decode(Date.self, forKey: .startDate)
        dueDate = try values.decodeIfPresent(Date.self, forKey: .dueDate)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(title, forKey: .title)
        try container.encodeIfPresent(userId, forKey: .userId)
        try container.encodeIfPresent(aimId, forKey: .aimId)
        try container.encode(completed, forKey: .completed)
        try container.encodeIfPresent(completionDate, forKey: .completionDate)
        try container.encodeIfPresent(createdTime, forKey: .createdTime)
        try container.encode(startDate, forKey: .startDate)
        try container.encodeIfPresent(dueDate, forKey: .dueDate)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encode(referenceDate, forKey: .referenceDate)
    }
}

extension Action {
    func inDateRange (from firstDate: Date, to secondDate: Date) -> Bool {
        let referenceDate: Date = self.startDate
        
        
        let firstDateStart = firstDate.dateStart()
        let secondDateEnd = secondDate.dateEnd()
        
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
        
        let rangeEnd = toDate.yesterday(.end)
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

