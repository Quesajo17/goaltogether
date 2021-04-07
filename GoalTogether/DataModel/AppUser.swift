//
//  AppUser.swift
//  GoalTogether
//
//  Created by Charlie Page on 4/3/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct AppUser: Codable, Identifiable {
    // Identifying Information
    @DocumentID var id: String?
    var firstName: String
    var lastName: String?
    var birthday: Date?
    // var profilePicture: UIImage?
    
    // Metadata
    var summary: String?
    
    // Preferences
    // var seasonView: Category?
    
    
    // Social
    // var groups: [Group]?
    // var friends: [User]?

}
