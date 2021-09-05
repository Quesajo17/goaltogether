//
//  TestUserProfile.swift
//  GoalTogetherTests
//
//  Created by Charlie Page on 5/19/21.
//

import Foundation
@testable import GoalTogether

class TestUserProfile {
    var userProfile: UserProfile
    var monthlyProfile: UserProfile
    var profilesList: [UserProfile]
    @Published var allProfiles: [UserProfile]
    
    static let shared = TestUserProfile()
    
    init() {
        self.userProfile = UserProfile(id: "charliepage",
                                       firstName: "Charlie",
                                       lastName: "Page",
                                       email: "test@website.com",
                                       summary: "Here's a summary of me",
                                       groupMembership: [
                                        GroupMembership(groupId: "acctgroup1", groupName: "Mastermind Group", membershipStatus: .active),
                                        GroupMembership(groupId: "acctgroup2", groupName: "Specialty Group", membershipStatus: .pending)
                                       ])
        
        self.monthlyProfile = UserProfile(id: "wallacewilliam",
                                          firstName: "Wallace",
                                          lastName: "William",
                                          email: "test@website2.com",
                                          summary: "Here's a summary of me",
                                          seasonLength: SeasonLength(rawValue: "month"))
        
        self.profilesList = [
                            UserProfile(id: "giannis",
                                        firstName: "Giannis",
                                        lastName: "Antetokounmpo",
                                        email: "test@website3.com",
                                        summary: "Here's a summary of Giannis",
                                        seasonLength: SeasonLength(rawValue: "quarter"),
                                        groupMembership: [
                                         GroupMembership(groupId: "acctgroup1", groupName: "Mastermind Group", membershipStatus: .pending)
                                            ])
        ]
        
        self.allProfiles = [self.userProfile, self.monthlyProfile]
        self.allProfiles += self.profilesList
    }
}
