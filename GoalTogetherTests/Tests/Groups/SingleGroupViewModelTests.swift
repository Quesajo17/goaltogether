//
//  SingleGroupViewModelTests.swift
//  GoalTogetherTests
//
//  Created by Charlie Page on 7/6/21.
//

import XCTest
@testable import GoalTogether


class SingleGroupViewModelTests: XCTestCase {

    var sut: SingleGroupViewModel!
    
    override func setUpWithError() throws {
        super.setUp()
        // reset TestUserProfiles.shared.allProfiles to its original list.
        TestUserProfile.shared.allProfiles = [TestUserProfile.shared.userProfile, TestUserProfile.shared.monthlyProfile]
        TestUserProfile.shared.allProfiles += TestUserProfile.shared.profilesList
        
        sut = SingleGroupViewModel(groupRepository: MockGroupsRepository(), groupUserRepository: MockGroupMemberUserRepository(), group: MockGroupsRepository().activeGroups[0], currentUser: MockCurrentUserProfile())
    }

    override func tearDownWithError() throws {
        sut = nil
        super.tearDown()
    }

    // This test makes sure that changing the name of the group saves the name in the group in the repository, as well as in all affected user profiles.
    func testSingleGroupViewModel_newGroupSaves() {
        // given
        
        // when
        sut.group.title = "New Group title"
        sut.updateGroup()
        
        // assert
        XCTAssertEqual(sut.groupRepository.activeGroups.count, 1)
        XCTAssertEqual("New Group title", sut.groupRepository.activeGroups[0].title)
        XCTAssertEqual("This is a mastermind group used for testing", sut.groupRepository.activeGroups[0].description)
    }

    // This test ensures that users listed as active on the user list have an activeUserViewModel, and users on the pendinguserlist have a pending user view model.
    func testSingleGroupViewModel_viewModels_activeAndPendingViewModels() {
        
        // assert
        XCTAssertEqual(sut.activeUserCellVMs.count, 1)
        XCTAssertEqual(sut.pendingUserCellVMs.count, 1)
        
    }
    
    // This test ensures that user listed as active in the user but pending in the group gets moved over to the appropriate view model, and that the group is updated.
    func testSingleGroupViewModel_ensureUserMatch_activeUserPendingGroup_fixedToMatchUser() {
        
    }
    
    // This test ensures that a user listed as pending in the user but active in the group gets moved over to the appropriate view model, and that the group is updated to match the user.
    func testSingleGroupViewModel_ensureUserMatch_pendingUserActiveGroup_fixedToMatchUser() {
        
    }
    
    // This test measures that a name change to the group gets propagated to all members of the group.
    func testSingleGroupViewModel_updateGroupName_propagatedToAllMatchingUsers() {
        
    }
    
    // This test measures that the user is added to the pending users view model immediately once the invite is selected.
    func testSingleGroupViewModel_addUser_newUserOnGroupAndPendingViewModel() {
        // given
        let testUser = TestUserProfile.shared.allProfiles[1]
        XCTAssertEqual(sut.pendingUserCellVMs.count, 1)
        
        // when
        do {
            try sut.inviteUser(user: testUser)
        } catch {
            print(error.localizedDescription)
        }
        
        let repositoryGroup = sut.groupRepository.activeGroups.first(where: { $0.id == sut.group.id })
        
        // assert
        XCTAssert(repositoryGroup?.pendingMembers?.contains(where: { $0 == testUser.id }) == true)
        XCTAssert(sut.group.pendingMembers?.contains(where: { $0 == testUser.id }) == true)
        XCTAssert(sut.pendingUserCellVMs.contains(where: { $0.user.id == testUser.id && $0.user.id != nil }) == true)
        XCTAssertEqual(sut.pendingUserCellVMs.count, 2)
        
    }
    
    // This test measures that the user profile is updated immediately once the invitation is sent.
    func testSingleGroupViewModel_addUser_newUserHasInvitationSentToThemImmediately() {
        
    }
    
    

    
}


class SingleGroupViewModelPendingGroupTests: XCTestCase {

    var sut: SingleGroupViewModel!
    
    override func setUpWithError() throws {
        super.setUp()
        // reset TestUserProfiles.shared.allProfiles to its original list.
        TestUserProfile.shared.allProfiles = [TestUserProfile.shared.userProfile, TestUserProfile.shared.monthlyProfile]
        TestUserProfile.shared.allProfiles += TestUserProfile.shared.profilesList
        
        sut = SingleGroupViewModel(groupRepository: MockGroupsRepository(), groupUserRepository: MockGroupMemberUserRepository(), group: MockGroupsRepository().pendingGroups[0], currentUser: MockCurrentUserProfile())
    }

    override func tearDownWithError() throws {
        sut = nil
        super.tearDown()
    }
    
    // This test measures that a user accepting is moved from the pending ViewModel to the activeViewModel once they accept.
    func testSingleGroupViewModel_acceptedInvitation_userMovesFromPendingToActiveVM() {
        // given
        let testUser = sut.currentUser.currentUser!
        
        // when
        do {
            try sut.acceptGroupInvitation()
        } catch {
            print(error.localizedDescription)
        }
        
        let repositoryGroup = sut.groupRepository.activeGroups.first(where: { $0.id == sut.group.id })
        let pendingGroupOption = sut.groupRepository.pendingGroups.first(where: { $0.id == sut.group.id })
        
        // assert
        XCTAssertNil(pendingGroupOption)
        XCTAssertEqual(sut.activeUserCellVMs.count, 1)
        XCTAssertEqual(sut.pendingUserCellVMs.count, 0)
        XCTAssert(repositoryGroup?.activeMembers?.contains(where: { $0 == testUser.id }) == true)
        XCTAssert(sut.activeUserCellVMs.contains(where: { $0.user.id == testUser.id && $0.user.id != nil }) == true)
    }
    
    // This test measures that a user accepting has their membership in the group updated.
    func testSingleGroupViewModel_acceptedInvitation_membershipInGroupUpdatedToActive() {
        // when
        do {
            try sut.acceptGroupInvitation()
        } catch {
            print(error.localizedDescription)
        }
        
        // assert
        XCTAssert(sut.group.activeMembers?.contains(where: { $0 == sut.currentUser.currentUser!.id! }) == true )
        XCTAssertFalse(sut.group.pendingMembers?.contains(where: { $0 == sut.currentUser.currentUser!.id! }) == true)
    }
    
    // This test measures that a user accepting an invitation from a group has their user updated to mark the group as active.
    func testSingleGroupViewModel_acceptGroupInvitation_groupInvitationMarkedActive() {
        // when
        do {
            try sut.acceptGroupInvitation()
        } catch {
            print(error.localizedDescription)
        }
        
        let user = sut.currentUser.currentUser!
        let membership = user.groupMembership?.first(where: { $0.groupId == sut.group.id })
        
        guard membership != nil else {
            XCTAssert(false)
            return
        }
        
        XCTAssert(membership!.membershipStatus == .active)
    }
    
    // This test measures that a user declining an invitation has their membership in the group removed.
    func testSingleGroupViewModel_declineGroupInvitation_userRemovedFromGroup() {
        // given
        
        XCTAssertEqual(sut.pendingUserCellVMs.count, 1)
        // when
        do {
            try sut.declineGroupInvitation()
        } catch {
            print(error.localizedDescription)
        }
        
        XCTAssertEqual(sut.activeUserCellVMs.count, 0)
        XCTAssertEqual(sut.pendingUserCellVMs.count, 0)
        XCTAssertFalse(sut.groupRepository.activeGroups.contains(where: { $0 == sut.group }))
        XCTAssertFalse(sut.groupRepository.pendingGroups.contains(where: { $0 == sut.group }))
    }
    
    // This test measures that a user accepting has their membership in the group updated.
    func testSingleGroupViewModel_declinedInvitation_membershipInGroupRemoved() {
        // when
        do {
            try sut.declineGroupInvitation()
        } catch {
            print(error.localizedDescription)
        }
        
        // assert
        XCTAssertFalse((sut.group.activeMembers?.contains(where: { $0 == sut.currentUser.currentUser!.id! })) == true)
        XCTAssertFalse(sut.group.pendingMembers?.contains(where: { $0 == sut.currentUser.currentUser!.id! }) == true)
    }
    
    // This test measures that a user declining an invitation has the group removed from their list in the UserProfile.
    func testSingleGroupViewModel_declineGroupInvitation_groupRemovedFromUser() {
        // when
        do {
            try sut.declineGroupInvitation()
        } catch {
            print(error.localizedDescription)
        }
        
        guard sut.currentUser.currentUser != nil else {
            XCTAssert(false)
            return
        }
        
        let membership = sut.currentUser.currentUser!.groupMembership!.first(where: { $0.groupId == sut.group.id })
        
        XCTAssertNil(membership)
    }

}
