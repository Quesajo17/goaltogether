//
//  MockGroupRepositoryTests.swift
//  GoalTogetherTests
//
//  Created by Charlie Page on 8/4/21.
//

import XCTest
@testable import GoalTogether

class MockGroupRepositoryTests: XCTestCase {

    var sut: GroupStoreType!
    var group: AccountabilityGroup!
    
    override func setUpWithError() throws {
        super.setUp()
        sut = MockGroupsRepository()
        group = MockGroupsRepository().activeGroups[0]
    }

    override func tearDownWithError() throws {
        sut = nil
        group = nil
        super.tearDown()
    }
    
    // This test attempts to send a new invitation, and checks if the groupRepository returns a pending invitation to be added to that group.
    func testGroupRepository_sendNewInvitation_returnsPendingInvitation() {
        // given
        let testUser = TestUserProfile.shared.allProfiles[1]
        var returnedGroup: AccountabilityGroup?
        var threwError: Bool = false
        
        // when
        do {
            returnedGroup = try sut.sendNewInvitation(group: group, user: testUser)
        } catch {
            threwError = true
        }
        
        // assert
        XCTAssertFalse(threwError)
        XCTAssertEqual(returnedGroup, group)
        XCTAssert(returnedGroup?.pendingMembers?.contains(where: { $0 == testUser.id }) == true)
    }
    
    // This test checks inviting a user to the group who is already invited, and makes sure they cannot be invited in the group again.
    func testGroupRepository_sendNewInvitation_noRepeatInvitation() {
        // given
        let testUser = TestUserProfile.shared.allProfiles[2]
        
        // assert
        XCTAssertThrowsError(try sut.sendNewInvitation(group: group, user: testUser), "User is already invited to the group and cannot be re-invited. This should have thrown an error.") { error in
            XCTAssertEqual(error as? ErrorUpdatingGroupMembership, ErrorUpdatingGroupMembership.userAlreadyInvited)
        }
    }
    
    // This test checks a pending member of the group, and verifies that the updateMembershipStatus function returns the group with the user id moved from the pending users list to the active users list.
    func testGroupRepository_activatesPendingUser_convertsPendingToActive() {
        // given
        let testUser = TestUserProfile.shared.allProfiles[2]
        var returnedGroup: AccountabilityGroup?
        var threwError: Bool = false
        
        // when
        do {
            returnedGroup = try sut.activatePendingUser(group: group, user: testUser)
        } catch {
            threwError = true
        }
        
        XCTAssertFalse(threwError)
        XCTAssertEqual(returnedGroup, group)
        XCTAssert(returnedGroup?.activeMembers?.contains(where: { $0 == testUser.id }) == true)
        XCTAssert(returnedGroup?.pendingMembers?.contains(where: { $0 == testUser.id }) == false)
    }
    
    // This test tests two error conditions for the updateMembershipStatus function - first, it tests an already active user, and then it tests a user who is not already a pending member of the group. In each of those cases, it should throw an error.
    func testGroupRepository_activatePendingUser_throwsErrors() {
        // given
        let alreadyActiveUser = TestUserProfile.shared.allProfiles[0]
        
        let nonMemberUser = TestUserProfile.shared.allProfiles[1]
        
        // assert
        XCTAssertThrowsError(try sut.activatePendingUser(group: group, user: alreadyActiveUser), "User is already an active member of the group and cannot be reset to active. This should have thrown an error but did not.") { error in
            XCTAssertEqual(error as? ErrorUpdatingGroupMembership, ErrorUpdatingGroupMembership.userAlreadyActive)
        }
        XCTAssertThrowsError(try sut.activatePendingUser(group: group, user: nonMemberUser), "User is not a member of a group and can't have membership updated. This should have thrown an error but did not.") { error in
            XCTAssertEqual(error as? ErrorUpdatingGroupMembership, ErrorUpdatingGroupMembership.noPendingInviteToActivate)
        }
    }
    
    // This test ensures that the "removeMemberFromGroup" function removes the membership for a user who is currently an active member of the group.
    func testGroupRepository_removeMemberFromGroup_removesMembership() {
        // given
        let testUser = TestUserProfile.shared.allProfiles[0]
        var returnedGroup: AccountabilityGroup?
        var threwError: Bool = false
        
        
        // when
        do {
            returnedGroup = try sut.removeMemberFromGroup(group: group, user: testUser)
        } catch {
            threwError = true
        }
        
        // assert
        XCTAssertFalse(threwError)
        XCTAssert(returnedGroup?.activeMembers?.contains(where: { $0 == testUser.id }) == false)
        XCTAssert(returnedGroup?.pendingMembers?.contains(where: { $0 == testUser.id }) == false)
    }
    
    // This test verifies that trying to remove the membership from a user who is not already a member of the group throws an error.
    func testGroupRepository_removeMemberFromGroup_errorForNonMember() {
        // given
        let testUser = TestUserProfile.shared.allProfiles[1]
        
        // assert
        XCTAssertThrowsError(try sut.removeMemberFromGroup(group: group, user: testUser), "User is not a member of a group and can't have membership updated. This should have thrown an error.") { error in
            XCTAssertEqual(error as? ErrorUpdatingGroupMembership, ErrorUpdatingGroupMembership.groupHasNoMember)
        }
    }

    
    // The membershipMethods_userIdMissingErrorThrown tests the group member update functions for a case where the user ID is blank, and makes sure they throw the appropriate error. This test covers the following functions:
    // sendNewInvitation
    // updateMembershipStatus
    // removeMemberFromGroup
    func testGroupRepository_membershipMethods_userIdMissingErrorThrown() {
        // given
        var testUser = TestUserProfile.shared.allProfiles[1]
        testUser.id = nil
        
        // assert
        XCTAssertThrowsError(try sut.sendNewInvitation(group: group, user: testUser), "Should have thrown a userHasNoId error, but no error was thrown.") { error in
            XCTAssertEqual(error as? ErrorUpdatingGroupMembership, ErrorUpdatingGroupMembership.userHasNoId)
        }
        
        XCTAssertThrowsError(try sut.activatePendingUser(group: group, user: testUser), "Should have thrown a userHasNoId error, but no error was thrown.") { error in
            XCTAssertEqual(error as? ErrorUpdatingGroupMembership, ErrorUpdatingGroupMembership.userHasNoId)
        }
        
        XCTAssertThrowsError(try sut.removeMemberFromGroup(group: group, user: testUser), "Should have thrown a userHasNoId error, but no error was thrown.") { error in
            XCTAssertEqual(error as? ErrorUpdatingGroupMembership, ErrorUpdatingGroupMembership.userHasNoId)
        }
    }
    
    // The membershipMethods_groupIdMissingErrorThrown tests the group member update functions for a case where the group ID is blank, and makes sure they throw the appropriate error. This test covers the following functions:
    // sendNewInvitation
    // activatePendingUser
    // removeMemberFromGroup
    // updateGroupName
    func testGroupRepository_membershipMethods_groupIdMissingErrorThrown() {
        // given
        let testUser = TestUserProfile.shared.allProfiles[1]
        group.id = nil
        

        
        // assert
        XCTAssertThrowsError(try sut.sendNewInvitation(group: group, user: testUser), "Should have thrown a groupHasNoId error, but no error was thrown.") { error in
            XCTAssertEqual(error as? ErrorUpdatingGroupMembership, ErrorUpdatingGroupMembership.groupHasNoId)
        }
        
        XCTAssertThrowsError(try sut.activatePendingUser(group: group, user: testUser), "Should have thrown a groupHasNoId error, but no error was thrown.") { error in
            XCTAssertEqual(error as? ErrorUpdatingGroupMembership, ErrorUpdatingGroupMembership.groupHasNoId)
        }
        
        XCTAssertThrowsError(try sut.removeMemberFromGroup(group: group, user: testUser), "Should have thrown a groupHasNoId error, but no error was thrown.") { error in
            XCTAssertEqual(error as? ErrorUpdatingGroupMembership, ErrorUpdatingGroupMembership.groupHasNoId)
        }
    }
    
    // This test ensures that the group membership in the test database is updated when we perform the updateUserMemberships function with a send new invitation function passed into it.
    func testGroupUserRepository_updateMembers_updatesGroupWithNewInvite() {
        // given
        let testUser = TestUserProfile.shared.allProfiles[1]
        var errorThrown: Bool = false
        
        // when
        do {
            try sut.updateMembers(group: try sut.sendNewInvitation(group: group, user: testUser))
        } catch {
            errorThrown = true
        }
        
        // assert
        XCTAssertFalse(errorThrown)
        XCTAssert(sut.activeGroups[0].pendingMembers?.contains(where: { $0 == testUser.id }) == true)
    }
    
    // This test ensures that sending an invitation through the updateUserMemberships function throws an error appropriately.
    func testGroupRepository_updateMembers_throwsError() {
        // given
        let testUser = TestUserProfile.shared.allProfiles[2]
        
        // assert
        XCTAssertThrowsError(try sut.updateMembers(group: try sut.sendNewInvitation(group: group, user: testUser)))
        
    }
}

