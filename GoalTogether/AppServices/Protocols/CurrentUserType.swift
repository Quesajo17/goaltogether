//
//  CurrentUserType.swift
//  GoalTogether
//
//  Created by Charlie Page on 6/8/21.
//

import Foundation

protocol CurrentUserType {
    
    var currentUser: UserProfile? { get set }
    var currentUserPublished: Published<UserProfile?> { get }
    var currentUserPublisher: Published<UserProfile?>.Publisher { get }
    
    func updateCurrentUserItems(firstName: String?, lastName: String?, email: String?, phoneNumber: String?, birthday: Date?, defaultSeason: String?, seasonLength: SeasonLength?, groupMembership: [GroupMembership]?) throws
    
    func updateCurrentUserFromUser(_ userProfile: UserProfile) throws
}


