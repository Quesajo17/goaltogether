//
//  Goal.swift
//  GoalTogether
//
//  Created by Charlie Page on 4/3/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Aim: Codable, Identifiable, Equatable {
    // Identifiers
    @DocumentID var id: String?
    var title: String
    var userId: String?
    var seasonId: String
    // Need to figure out how to render categories in Swift and in Firebase
    // var privateStatus: Category
    
    //Completion Details
    var startDate: Date
    var plannedEndDate: Date
    var completed: Bool
    var completionDate: Date?
    
    // details
    var description: String?
    var actions: [Action]?
    // Can I set this as an optional value? Or does it need to be a full value?
    
    init(title: String, user: UserProfile, season: Season) {
        guard season.id != nil else {
            fatalError("Tried to load an aim with a nil season ID")
        }
        
        self.title = title
        self.userId = user.id
        self.seasonId = season.id!
        
        self.startDate = Date()
        self.plannedEndDate = season.endDate
        self.completed = false
        
    }
    
    init(id: String?, title: String, userId: String?, seasonId: String, startDate: Date, plannedEndDate: Date, completed: Bool, completionDate: Date?, description: String?, actions: [Action]?) {
        self.id = id
        self.title = title
        self.userId = userId
        self.seasonId = seasonId
        self.startDate = startDate
        self.plannedEndDate = plannedEndDate
        self.completed = completed
        self.completionDate = completionDate
        self.description = description
        self.actions = actions
    }
}

