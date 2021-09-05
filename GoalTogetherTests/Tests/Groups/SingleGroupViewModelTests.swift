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
        
        sut = SingleGroupViewModel(groupRepository: MockGroupsRepository(), groupUserRepository: MockGroupMemberUserRepository(), group: MockGroupsRepository().accountabilityGroups[0], currentUser: MockCurrentUserProfile())
    }

    override func tearDownWithError() throws {
        sut = nil
        super.tearDown()
    }

    // This test makes sure that changing the name of the group saves the name in the group in the repository, as well as in all affected user profiles.
    func testSingleGroupViewModel_newGroupSaves() {
        // given
        sut.group.title = "New Group title"
        
        // when
        sut.updateGroup()
        
        // assert
        XCTAssertEqual(sut.groupRepository.accountabilityGroups.count, 2)
        XCTAssertEqual("New Group title", sut.groupRepository.accountabilityGroups[0].title)
        XCTAssertEqual("This is a mastermind group used for testing", sut.groupRepository.accountabilityGroups[0].description)
    }

    // This test ensures that users listed as active on the user list have an activeUserViewModel, and users on the pendinguserlist have a pending user view model.
    func testSingleGroupViewModel_viewModels_activeAndPendingViewModels() {
        
        // assert
        XCTAssertEqual(sut.activeMemberVMs.count, 1)
        XCTAssertEqual(sut.pendingMemberVMs.count, 1)
        
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
        XCTAssertEqual(sut.pendingMemberVMs.count, 1)
        
        // when
        do {
            try sut.inviteUser(user: testUser)
        } catch {
            print(error.localizedDescription)
        }
        
        // assert
        XCTAssert(sut.group.members?.contains(where: { $0.userId == testUser.id }) == true)
        XCTAssert(sut.pendingMemberVMs.contains(where: { $0.user.id == testUser.id && $0.user.id != nil }) == true)
        XCTAssertEqual(sut.pendingMemberVMs.count, 2)
        
    }
    
    // This test measures that the user profile is updated immediately once the invitation is sent.
    func testSingleGroupViewModel_addUser_newUserHasInvitationSentToThemImmediately() {
        
    }
    
    
    // This test measures that a user accepting is moved from the pending ViewModel to the activeViewModel once they accept.
    func testSingleGroupViewModel_acceptedInvitation_userMovesFromPendingToActiveVM() {
        
    }
    
    // This test measures that a user accepting has their membership in the group updated.
    func testSingleGroupViewModel_acceptedInvitation_membershipInGroupUpdatedToActive() {
        
    }
}
