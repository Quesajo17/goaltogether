//
//  Practice.swift
//  GoalTogether
//
//  Created by Charlie Page on 4/3/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Practice: Codable, Identifiable {
    @DocumentID var id: String?
}
