//
//  GroupHubViewModelTests.swift
//  GoalTogetherTests
//
//  Created by Charlie Page on 8/23/21.
//

import XCTest
@testable import GoalTogether

class GroupHubViewModelTests: XCTestCase {

    var sut: GroupHubViewModel!
    
    override func setUpWithError() throws {
        super.setUp()
        sut = GroupHubViewModel(groupRepository: MockGroupsRepository(), currentUser: MockCurrentUserProfile())
    }

    override func tearDownWithError() throws {
        sut = nil
        super.tearDown()
    }

    // This test checks loading of active groups and verifies that upon initialization, the groupHubViewModel will contain some relevant active groups.
    func testGroupHubViewModel_loadActiveGroups_containsActiveGroups() {
        // when
        let count = sut.activeGroupViewModels.count
        
        // assert
        XCTAssertEqual(count, 1)
    }
    
    // This test checks loading of pendingInvitations and verifies that upon initialization of the VM, the groupHubViewModel will contain any pending invitations
    func testGroupHubViewModel_loadPendingInvitations_containsInvites() {
        // when
        let count = sut.pendingInviteViewModels.count
        
        // assert
        XCTAssertEqual(count, 1)
    }
    
    // This test checks accepting a pending invitation and makes sure that the group's membership has been updated to active status.
    func testGroupHubViewModel_acceptPendingInvitation_updatesGroup() {
        // given
        let testGroup = sut.groupRepository.accountabilityGroups[1]
        let userId = sut.currentUser.currentUser?.id
        
        guard userId != nil else {
            XCTAssert(false)
            return
        }
        
        // when
        do {
            try sut.acceptInvitationTo(testGroup)
        } catch {
            XCTAssert(false)
            return
        }
        
        // assert
        XCTAssert(((sut.groupRepository.accountabilityGroups[1].members?.contains(where: { $0.userId == userId && $0.membershipStatus == .active })) == true))
    }
    
    // This test checks accepting a pending invitation and makes sure that the user's membership has been updated to active status.
    func testGroupHubViewModel_acceptPendingInvitation_updatesUser() {
        // given
        let testGroup = sut.groupRepository.accountabilityGroups[1]
        let userId = sut.currentUser.currentUser?.id
        
        guard userId != nil else {
            XCTAssert(false)
            return
        }
        
        // when
        do {
            try sut.acceptInvitationTo(testGroup)
        } catch {
            XCTAssert(false)
            return
        }
        
        // assert
        XCTAssert(((sut.currentUser.currentUser?.groupMembership?.contains(where: { $0.groupId == testGroup.id && $0.membershipStatus == .active })) == true))
    }

    // This test checks accepting a pending invitation and makes sure that the accepted group has now moved from the pending view models to the active view models.
    func testGroupHubViewModel_acceptPendingInvitation_groupMovesFromPendingToActive() {
        // given
        let testGroup = sut.groupRepository.accountabilityGroups[1]
        let userId = sut.currentUser.currentUser?.id
        
        guard userId != nil else {
            XCTAssert(false)
            return
        }
        
        // when
        do {
            try sut.acceptInvitationTo(testGroup)
        } catch {
            XCTAssert(false)
            return
        }
        
        let activeCount = sut.activeGroupViewModels.count
        let pendingCount = sut.pendingInviteViewModels.count
        
        // assert
        XCTAssertEqual(activeCount, 2)
        XCTAssertEqual(pendingCount, 0)
    }
}
