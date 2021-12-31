//
//  MockGroupUserRepositoryTests.swift
//  GoalTogetherTests
//
//  Created by Charlie Page on 8/4/21.
//

import XCTest
@testable import GoalTogether

class MockGroupUserRepositoryTests: XCTestCase {

    var sut: GroupUserStoreType!
    var group: AccountabilityGroup!
    
    override func setUpWithError() throws {
        super.setUp()
        sut = MockGroupMemberUserRepository()
        group = MockGroupsRepository().activeGroups[0]
    }

    override func tearDownWithError() throws {
        sut = nil
        group = nil
        super.tearDown()
    }
    
    // This test attempts to send a new invitation, and checks if the new group member repository
    func testGroupUserRepository_sendNewInvitation_returnsPendingInvitation() {
        // given
        let testUser = TestUserProfile.shared.allProfiles[1]
        var userAndMembership: (UserProfile, [GroupMembership])?
        var threwError: Bool = false
        
        // when
        do {
            userAndMembership = try sut.sendNewInvitation(user: testUser, group: group)
        } catch {
            threwError = true
        }
        
        // assert
        XCTAssertFalse(threwError)
        XCTAssertEqual(userAndMembership?.0, testUser)
        XCTAssert(userAndMembership?.1.contains(where: { $0.groupId == group.id && $0.groupName == group.title && $0.membershipStatus == .pending}) == true)
    }
    
    // This test checks inviting a user to the group who is already invited, and makes sure they cannot be invited in the user profile again.
    func testGroupUserRepository_sendNewInvitation_noRepeatInvitation() {
        // given
        let testUser = TestUserProfile.shared.allProfiles[2]
        
        // assert
        XCTAssertThrowsError(try sut.sendNewInvitation(user: testUser, group: group), "User is already invited to the group and cannot be re-invited. This should have thrown an error.") { error in
            XCTAssertEqual(error as? ErrorUpdatingUserMembership, ErrorUpdatingUserMembership.userAlreadyInvited)
        }
    }
    
    // This test checks a pending member of the group, and verifies that the updateMembershipStatus function returns a tuple with a membership that is now updated to active for this group.
    func testGroupUserRepository_updateMembershipStatus_convertsPendingToActive() {
        // given
        let testUser = TestUserProfile.shared.allProfiles[2]
        var userAndMembership: (UserProfile, [GroupMembership])?
        var threwError: Bool = false
        
        // when
        do {
            userAndMembership = try sut.updateMembershipStatus(user: testUser, group: group, newStatus: .active)
        } catch {
            threwError = true
        }
        
        XCTAssertFalse(threwError)
        XCTAssertEqual(userAndMembership?.0, testUser)
        XCTAssert(userAndMembership?.1.contains(where: { $0.groupId == group.id && $0.groupName == group.title && $0.membershipStatus == .active}) == true)
    }
    
    // This test tests two error conditions for the updateUserMembershipStatus function - first, it tests an already active user, and then it tests a user who is not already a pending member of the group. In each of those cases, it should throw an error.
    func testGroupUserRepository_updateMembershipStatus_throwsErrors() {
        // given
        let alreadyActiveUser = TestUserProfile.shared.allProfiles[0]
        
        let nonMemberUser = TestUserProfile.shared.allProfiles[1]
        
        // assert
        XCTAssertThrowsError(try sut.updateMembershipStatus(user: alreadyActiveUser, group: group, newStatus: .active), "User is already an active member of the group and cannot be reset to active. This should have thrown an error but did not.") { error in
            XCTAssertEqual(error as? ErrorUpdatingUserMembership, ErrorUpdatingUserMembership.updatesMatchCurrentUserMemberships)
        }
        XCTAssertThrowsError(try sut.updateMembershipStatus(user: nonMemberUser, group: group, newStatus: .active), "User is not a member of a group and can't have membership updated. This should have thrown an error but did not.") { error in
            XCTAssertEqual(error as? ErrorUpdatingUserMembership, ErrorUpdatingUserMembership.userHasNoMembership)
        }
    }
    
    // This test ensures that the "removeMembershipFromUser" function removes the membership for a user who is currently an active member of the group.
    func testGroupUserRepository_removeMembershipFromUser_removesMembership() {
        // given
        let testUser = TestUserProfile.shared.allProfiles[0]
        var userAndMembership: (UserProfile, [GroupMembership])?
        var threwError: Bool = false
        
        
        // when
        do {
            userAndMembership = try sut.removeMembershipFromUser(user: testUser, group: group)
        } catch {
            threwError = true
        }
        
        // assert
        XCTAssertFalse(threwError)
        XCTAssert(userAndMembership?.1.contains(where: { $0.groupId == group.id }) == false)
    }
    
    // This test verifies that trying to remove the membership from a user who is not already a member of the group throws an error.
    func testGroupUserRepository_removeMembershipFromUser_errorForNonMember() {
        // given
        let testUser = TestUserProfile.shared.allProfiles[1]
        
        // assert
        XCTAssertThrowsError(try sut.removeMembershipFromUser(user: testUser, group: group), "User is not a member of a group and can't have membership updated. This should have thrown an error.") { error in
            XCTAssertEqual(error as? ErrorUpdatingUserMembership, ErrorUpdatingUserMembership.userHasNoMembership)
        }
    }
    
    func testGroupUserRepository_updateMembershipGroupName_updatesName() {
        // given
        let newName = "Test The Group Name Change"
        let testUser = TestUserProfile.shared.allProfiles[2]
        var userAndMembership: (UserProfile, [GroupMembership])?
        var threwError: Bool = false
        
        // when
        do {
            userAndMembership = try sut.updateMembershipGroupName(user: testUser, group: group, newName: newName)
        } catch {
            threwError = true
        }
        
        XCTAssertFalse(threwError)
        XCTAssertEqual(userAndMembership?.0, testUser)
        XCTAssert(userAndMembership?.1.contains(where: { $0.groupId == group.id && $0.groupName == newName && $0.membershipStatus == .pending}) == true)
        
    }
    
    func testGroupUserRepository_updateMembershipGroupName_noUpdateForNonMember() {
        // given
        let newName = "Test The Group Name Change"
        let testUser = TestUserProfile.shared.allProfiles[1]
        
        
        XCTAssertThrowsError(try sut.updateMembershipGroupName(user: testUser, group: group, newName: newName), "User is not a member of a group and can't have membership updated. This should have thrown an error.") { error in
            XCTAssertEqual(error as? ErrorUpdatingUserMembership, ErrorUpdatingUserMembership.userHasNoMembership)
        }
        
    }
    
    // The membershipMethods_userIdMissingErrorThrown tests the user group membership update functions for a case where the user ID is blank, and makes sure they throw the appropriate error. This test covers the following functions:
    // sendNewInvitation
    // updateMembershipStatus
    // removeMembershipFromUser
    // updateMembershipGroupName
    func testGroupUserRepository_membershipMethods_userIdMissingErrorThrown() {
        // given
        var testUser = TestUserProfile.shared.allProfiles[1]
        testUser.id = nil
        
        // assert
        XCTAssertThrowsError(try sut.sendNewInvitation(user: testUser, group: group), "Should have thrown a groupHasNoId error, but no error was thrown.") { error in
            XCTAssertEqual(error as? ErrorUpdatingUserMembership, ErrorUpdatingUserMembership.userHasNoId)
        }
        
        XCTAssertThrowsError(try sut.updateMembershipStatus(user: testUser, group: group, newStatus: .active), "Should have thrown a groupHasNoId error, but no error was thrown.") { error in
            XCTAssertEqual(error as? ErrorUpdatingUserMembership, ErrorUpdatingUserMembership.userHasNoId)
        }
        
        XCTAssertThrowsError(try sut.removeMembershipFromUser(user: testUser, group: group), "Should have thrown a groupHasNoId error, but no error was thrown.") { error in
            XCTAssertEqual(error as? ErrorUpdatingUserMembership, ErrorUpdatingUserMembership.userHasNoId)
        }
        
        XCTAssertThrowsError(try sut.updateMembershipGroupName(user: testUser, group: group, newName: "Test Name"), "Should have thrown a groupHasNoId error, but no error was thrown.") { error in
            XCTAssertEqual(error as? ErrorUpdatingUserMembership, ErrorUpdatingUserMembership.userHasNoId)
        }
    }
    
    // The membershipMethods_groupIdMissingErrorThrown tests the user group membership update functions for a case where the group ID is blank, and makes sure they throw the appropriate error. This test covers the following functions:
    // sendNewInvitation
    // updateMembershipStatus
    // removeMembershipFromUser
    // updateMembershipGroupName
    func testGroupUserRepository_membershipMethods_groupIdMissingErrorThrown() {
        // given
        let testUser = TestUserProfile.shared.allProfiles[1]
        group.id = nil
        

        
        // assert
        XCTAssertThrowsError(try sut.sendNewInvitation(user: testUser, group: group), "Should have thrown a groupHasNoId error, but no error was thrown.") { error in
            XCTAssertEqual(error as? ErrorUpdatingUserMembership, ErrorUpdatingUserMembership.groupHasNoId)
        }
        
        XCTAssertThrowsError(try sut.updateMembershipStatus(user: testUser, group: group, newStatus: .active), "Should have thrown a groupHasNoId error, but no error was thrown.") { error in
            XCTAssertEqual(error as? ErrorUpdatingUserMembership, ErrorUpdatingUserMembership.groupHasNoId)
        }
        
        XCTAssertThrowsError(try sut.removeMembershipFromUser(user: testUser, group: group), "Should have thrown a groupHasNoId error, but no error was thrown.") { error in
            XCTAssertEqual(error as? ErrorUpdatingUserMembership, ErrorUpdatingUserMembership.groupHasNoId)
        }
        
        XCTAssertThrowsError(try sut.updateMembershipGroupName(user: testUser, group: group, newName: "Test Name"), "Should have thrown a groupHasNoId error, but no error was thrown.") { error in
            XCTAssertEqual(error as? ErrorUpdatingUserMembership, ErrorUpdatingUserMembership.groupHasNoId)
        }
    }
    
    // This test ensures that the group membership in the test database is updated when we perform the updateUserMemberships function with a send new invitation function passed into it.
    func testGroupUserRepository_updateUserMemberships_updatesUserWithNewInvite() {
        // given
        let testUser = TestUserProfile.shared.allProfiles[1]
        var errorThrown: Bool = false
        
        // when
        do {
            try sut.updateUserMemberships(userAndMemberships: try sut.sendNewInvitation(user: testUser, group: group))
        } catch {
            errorThrown = true
        }
        
        // assert
        XCTAssertFalse(errorThrown)
        XCTAssert(TestUserProfile.shared.allProfiles[1].groupMembership?.contains(where: { $0.groupId == group.id && $0.groupName == group.title && $0.membershipStatus == .pending}) == true)
        
    }
    
    // This test ensures that sending an invitation through the updateUserMemberships function throws an error appropriately.
    func testGroupUserRepository_updateUserMemberships_throwsError() {
        // given
        let testUser = TestUserProfile.shared.allProfiles[2]
        
        // assert
        XCTAssertThrowsError(try sut.updateUserMemberships(userAndMemberships: try sut.sendNewInvitation(user: testUser, group: group)))
        
    }
}
