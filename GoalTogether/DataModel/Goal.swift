//
//  Goal.swift
//  GoalTogether
//
//  Created by Charlie Page on 4/3/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Goal: Codable, Identifiable {
    // Identifiers
    @DocumentID var id: String?
    var title: String
    var userId: String
    // Need to figure out how to render categories in Swift and in Firebase
    // var privateStatus: Category
    
    //Completion Details
    var startDate: Date
    var plannedEndDate: Date
    var completed: Bool
}
