//
//  UserProfile.swift
//  GoalTogether
//
//  Created by Charlie Page on 4/3/21.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct UserProfile: Codable, Identifiable {
    // Identifying Information
    @DocumentID var id: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    var phoneNumber: String?
    var birthday: Date?
    var profileImagePhoto: String?
    
    // Metadata
    var summary: String?

}
