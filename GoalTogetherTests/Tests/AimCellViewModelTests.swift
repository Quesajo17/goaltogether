//
//  AimCellViewModelTests.swift
//  GoalTogetherTests
//
//  Created by Charlie Page on 6/29/21.
//

import XCTest
@testable import GoalTogether

class AimCellViewModelTests: XCTestCase {

    var sut: MyAimCellViewModel!
    
    override func setUpWithError() throws {
        super.setUp()
        sut = MyAimCellViewModel(
            aimRepository: MockAimsRepository(),
            aim: TestAims(season: Season(userProfile: MockCurrentUserProfile().currentUser!, referenceDate: Date(), lastOrder: 3, id: "newSeasonID")).aimsCollection[0],
            aimActionRepository: MockAimActionRepository(aim: TestAims(season: Season(userProfile: MockCurrentUserProfile().currentUser!, referenceDate: Date(), lastOrder: 3, id: "newSeasonID")).aimsCollection[0])
        )
    }

    override func tearDownWithError() throws {
        sut = nil
        super.tearDown()
    }

    func testAimCellVM_noActionDetails() {
        // given
        let count = sut.actions?.count
        
        // when
        
        // assert
        XCTAssertEqual(count, 0)
        XCTAssertFalse(sut.detailsLoaded)
    }
    
    func testAimCellVM_loadActionDetails_hasActions() {
        // given
        
        
        // when
        sut.loadAimDetails()
        let count = sut.actions?.count
        
        // assert
        XCTAssertNotNil(count)
        XCTAssertEqual(count, 2)
        XCTAssert(sut.detailsLoaded)
        
    }
    
    func testAimCellVM_addAction_canAdd() {
        // given
        sut.loadAimDetails()
        
        // when
        let testAction = Action(title: "Third test Action for this Goal")
        sut.addAction(testAction)
        let count = sut.actions?.count
        
        // assert
        XCTAssertEqual(count, 3)
    }
    
    func testAimCellVM_updateAction_canUpdate() {
        // given
        sut.loadAimDetails()
        var modifyingAction = sut.actions![0]
        
        // when
        modifyingAction.title = "Updated Title"
        sut.updateAction(modifyingAction)
        let count = sut.actions?.count
        let actionUnderTest = sut.actions![0]
        
        // assert
        XCTAssertEqual(count, 2)
        XCTAssertEqual(actionUnderTest.title, "Updated Title")
    }

}
