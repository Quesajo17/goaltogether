//
//  SeasonGoalsViewModel.swift
//  GoalTogetherTests
//
//  Created by Charlie Page on 5/18/21.
//

import XCTest
@testable import GoalTogether

class SeasonAimsViewModelTests: XCTestCase {
    
    var sut: SeasonAimsViewModel!
    
    override func setUp() {
        super.setUp()
        sut = SeasonAimsViewModel(
            aimRepository: MockAimsRepository(),
            seasonRepository: MockSeasonRepository(testProfiles: MockCurrentUserProfile(), db: TestSeasons().seasonsCollectionQuarterlyNoCurrent),
            currentUser: MockCurrentUserProfile()
        )
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    /// Test that the current season is missing by default.
    func testSeasonAimsVM_noSeasonLength_currentSeasonMissing() {
        // given
        
        // when
        let currentUser = sut.currentUser.currentUser
        let seasonLength = sut.seasonLength
        let userSeasonLength = currentUser?.seasonLength
        let defaultSeason = sut.defaultSeason
            
        // assert
        XCTAssertNotNil(currentUser)
        XCTAssertNil(seasonLength)
        XCTAssertNil(userSeasonLength)
        XCTAssertNil(defaultSeason)
    }
    
    /// Test that adding a season length to the user profile leads to a season being created.
    func testSeasonAimsVM_addSeasonLength_currentSeasonAdded() {
        // given
        XCTAssertNotNil(sut.currentUser.currentUser)

        // when
        sut.seasonLength = .quarter
        let currentUserSeasonLength = sut.currentUser.currentUser?.seasonLength
        let defaultSeason = sut.defaultSeason
        
        // assert
        XCTAssertNotNil(currentUserSeasonLength, "currentSeason is still nil, even after seasonLength is set")
        XCTAssert(defaultSeason!.id == "newSeasonID")
        XCTAssert(defaultSeason!.startDate == Date().startOfPeriod(currentUserSeasonLength!))
        XCTAssert(defaultSeason!.endDate == Date().endOfPeriod(sut.seasonLength!))
    }
    
    func testSeasonAimsVM_addSeasonLength_findsExistingSeasonFromUser() {
        // given
        sut = SeasonAimsViewModel(
            aimRepository: MockAimsRepository(),
            seasonRepository: MockSeasonRepository(testProfiles: MockCurrentUserProfile(), db: TestSeasons().seasonsCollectionMonthlyCurrent),
            currentUser: MockCurrentUserProfile()
        )
        XCTAssertNotNil(sut.currentUser.currentUser)
        sut.currentUser.currentUser!.defaultSeason = "mCThisM"
        
        // when

        sut.seasonLength = .month
        
        
        // assert
        XCTAssert(sut.defaultSeason!.id == "mCThisM")
        XCTAssert(sut.currentUser.currentUser!.defaultSeason == "mCThisM")
    }
    
    func testSeasonAimsVM_addSeasonLength_findsExistingSeasonFromLookback() {
        // given
        sut = SeasonAimsViewModel(
            aimRepository: MockAimsRepository(),
            seasonRepository: MockSeasonRepository(testProfiles: MockCurrentUserProfile(), db: TestSeasons().seasonsCollectionMonthlyCurrent),
            currentUser: MockCurrentUserProfile()
        )
        XCTAssertNotNil(sut.currentUser.currentUser)
    
        // when
        sut.seasonLength = .month
        
        
        // assert
        XCTAssert(sut.defaultSeason!.id == "mCThisM")
        XCTAssert(sut.currentUser.currentUser!.defaultSeason == "mCThisM")
    }
    
    func testSeasonAimsVM_loadData() {
        // given
        sut.seasonLength = .quarter
        
        // when
        let count = sut.aimCellViewModels.count
        
        
        // assert
        XCTAssertEqual(count, 3)
    }
    
    func testSeasonAimsVM_loadDetails() {
        
    }
    
    func testSeasonAimsVM_addGoal_canAdd() {
        //given
        sut.seasonLength = .quarter
        
        // when
        let testAim = Aim(id: "Goal4", title: "New test goal.", userId: sut.currentUser.currentUser?.id, seasonId: "newSeasonID", startDate: Date(), plannedEndDate: sut.featuredSeason!.endDate, completed: false, completionDate: nil, description: nil, actions: nil)
        
        sut.addAim(testAim)
        let count = sut.aimCellViewModels.count
        
        XCTAssertEqual(count, 4)
    }
    
    func testSeasonAimsVM_updateAction_canUpdate() {
        // given
        sut.seasonLength = .quarter
        
        // when
        let aimsList = sut.aimRepository.aims
        var editAim = aimsList[1]
        
        editAim.title = "newAimTitle"
        sut.updateAim(editAim)
        
        // assert
        XCTAssertEqual(sut.aimCellViewModels[1].aim.title, "newAimTitle")
        XCTAssertEqual(sut.aimCellViewModels[1].aim.id, "Goal2")
    }
    
    func testSeasonAimsVM_removeAction_canRemove() {
        
    }
    
    func testSeasonAimsVM_changeSeason_includesPastAction() {
        
    }
}
