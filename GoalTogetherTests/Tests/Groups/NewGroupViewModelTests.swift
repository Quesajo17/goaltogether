//
//  NewGroupViewModelTests.swift
//  GoalTogetherTests
//
//  Created by Charlie Page on 7/10/21.
//

import XCTest
@testable import GoalTogether

class NewGroupViewModelTests: XCTestCase {

    var sut: NewGroupViewModel!
    
    override func setUpWithError() throws {
        super.setUp()
        sut = NewGroupViewModel(groupRepository: MockGroupsRepository(), groupUserRepository: MockGroupMemberUserRepository(), currentUser: MockCurrentUserProfile())
        sut.group.title = "New Group title"
        sut.group.description = "New Group Description!"
    }

    override func tearDownWithError() throws {
        sut = nil
        super.tearDown()
    }

    // This test verifies that a newGroup can be saved to the groupRepository
    func testNewGroupViewModel_saveGroup_newGroupSaves() {
        // given

        
        // when
        do {
            try sut.saveGroup()
        } catch {
            print(error)
        }
        
        // assert
        XCTAssertEqual(sut.groupRepository.accountabilityGroups.count, 3)
    }

    // This test verifies that upon saving, my user is automatically added to the group as a new member.
    func testNewGroupViewModel_newGroup_AutoAddMeAsMember() {
        // given
        
        // when
        do {
            try sut.saveGroup()
        } catch {
            print(error)
        }
        let groupMembership = sut.groupRepository.accountabilityGroups[0].members
        // finds the first listed member in the group.
        let firstMember = groupMembership![0]
        
        // assert
        XCTAssertNotNil(groupMembership)
        XCTAssertEqual(firstMember.userId, sut.currentUser.currentUser!.id)
        XCTAssertEqual(firstMember.membershipStatus, .active)
    }
    
    // This test verifies that upon saving, my user has this group saved to the user profile, as an active member.
    func testNewGroupViewModel_sendInvitations_AutoAddGrouptoMyUser() {
        // given
        
        // when
        do {
            try sut.saveGroup()
        } catch {
            print(error)
        }
        let userGroups = sut.currentUser.currentUser?.groupMembership
        // finds the first listed group membership in my User
        let newAddedGroup: GroupMembership? = userGroups?[2]
        
        // assert
        XCTAssertNotNil(newAddedGroup)
        XCTAssertEqual(newAddedGroup!.groupId, sut.group.id)
        XCTAssertEqual(newAddedGroup!.groupName, sut.group.title)
        XCTAssertEqual(newAddedGroup!.membershipStatus, .active)
    }
    
    // This test verifies that using the addUser function will add the new user to both the pending users list as well as the pendingUsersViewModel list.
    func testNewGroupViewModel_addUser_NewUserOnPendingListAndViewModel() {
        // given
        let userStore = MockUserSearchRepository()
        // sets this to the test user - Wallace William.
        let testUser = userStore.users[1]
        
        // when
        do {
            try sut.addUser(testUser)
        } catch {
            
        }
        
        // assert
        XCTAssert(sut.pendingInvitees.contains(testUser))
        XCTAssert(sut.pendingInviteeViewModels.contains(where: { $0.user == testUser }))
        XCTAssertEqual(sut.pendingInvitees.count, 2)
        XCTAssertEqual(sut.pendingInviteeViewModels.count, 2)
    }
    
    // This test verifies that adding the same user twice still only results in that user being added once.
    func testNewGroupViewModel_addUser_onlyAddUserOneTime() {
        // given
        let userStore = MockUserSearchRepository()
        // sets this to the test user - Wallace William.
        let testUser = userStore.users[1]
        var errorTriedToAddAUserTwice: Bool = false
        
        do {
            try sut.addUser(testUser)
        } catch {
            
        }
        
        // when
        do {
            try sut.addUser(testUser)
        } catch {
            errorTriedToAddAUserTwice = true
        }
        
        // assert
        XCTAssert(errorTriedToAddAUserTwice)
        XCTAssertEqual(sut.pendingInvitees.count, 2)
        XCTAssertEqual(sut.pendingInviteeViewModels.count, 2)
    }
    
    // This test verifies that adding users without saving the group does not update the group membership on either the user or the group.
    func testNewGroupViewModel_addUser_NoUsersUpdatedOnGroupOrUserBeforeSave() {
        // given
        let userStore = MockUserSearchRepository()
        // sets this to the test user - Wallace William.
        let testUser = userStore.users[1]
        
        // when
        do {
            try sut.addUser(testUser)
        } catch {
            print(error)
        }
        let groupMemberships = sut.group.members
        let count = sut.currentUser.currentUser!.groupMembership!.count
        
        // assert
        XCTAssertNil(groupMemberships)
        XCTAssertEqual(count, 2)
        XCTAssertNil(sut.pendingInvitees[1].groupMembership)
    }
    
    // This test verifies that an added user who is saved to the group will be listed on the group list after it is saved.
    
    // Still need to make sure it can send the invite.
    func testNewGroupViewModel_addPendingUsersToGroup_newUserOnGroupListAfterSave() {
        // given
        let userStore = MockUserSearchRepository()
        // sets this to the test user - Wallace William.
        let testUser = userStore.users[1]
        
        // when
        do {
            try sut.addUser(testUser)
        } catch {
            
        }
        do {
            try sut.saveGroup()
        } catch {
            print(error)
        }
        
        let groupMemberships: [UserMembership] = sut.group.members!
        let firstGroupMember = groupMemberships[0]
        let secondGroupMember = groupMemberships[1]
        
        // assert
        XCTAssertEqual(firstGroupMember.userId, sut.currentUser.currentUser!.id)
        XCTAssertEqual(firstGroupMember.membershipStatus, .active)
        XCTAssertEqual(secondGroupMember.userId, testUser.id)
        XCTAssertEqual(secondGroupMember.membershipStatus, .pending)
    }
    
    // This test verifies that saving the group with a new user added will add the group to a new user.
    func testNewGroupViewModel_sendInvitation_groupAddedToNewUser() {
        // given

        // sets this to the test user - Wallace William.
        let testUser = TestUserProfile.shared.allProfiles[1]
        
        // when
        do {
            try sut.addUser(testUser)
        } catch {
            
        }
        
        do {
            try sut.saveGroup()
        } catch {
            print(error)
        }
            
        let currentUserMembership: GroupMembership = sut.currentUser.currentUser!.groupMembership![2]
        let additionalUserMembership: GroupMembership? = TestUserProfile.shared.allProfiles[1].groupMembership?[0]
        
        // assert
        XCTAssertEqual(currentUserMembership.groupId, sut.group.id)
        XCTAssertEqual(currentUserMembership.membershipStatus, .active)
        XCTAssertNotNil(additionalUserMembership)
        XCTAssertEqual(additionalUserMembership?.groupId, sut.group.id)
        XCTAssertEqual(additionalUserMembership?.membershipStatus, .pending)
    }
}
