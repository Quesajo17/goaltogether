//
//  ActionListViewModelTests.swift
//  GoalTogetherTests
//
//  Created by Charlie Page on 4/3/21.
//

import XCTest
@testable import GoalTogether

class ActionListViewModelTests: XCTestCase {

    var sut: ActionListViewModel!
    
    override func setUp() {
        super.setUp()
        sut = ActionListViewModel(actionRepository: MockActionRepository())
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testActionListVM_loadData() {
        // given
        let count = sut.actionRepository.actions.count
        
        // when
        
        // assert
        XCTAssertEqual(count, 5)
    }
    
    func testActionListVM_addAction_canAdd() {
        // given
        let testAction = Action(title: "Test Action specific to the canAdd test.")
        
        // when
        sut.addAction(testAction)
        
        // assert
        XCTAssertTrue(sut.actionRepository.actions.contains(where: { $0.title == testAction.title}))
    }
    
    func testActionListVM_updateAction_canUpdate() {
        // given
        var updatedAction = sut.actionRepository.actions[0]
        
        // when
        updatedAction.title = "New updated action title"
        sut.updateAction(updatedAction)
        
        // assert
        XCTAssertTrue(sut.actionRepository.actions[0].title == "New updated action title")
    }

    func testActionListVM_removeAction_canRemove() {
        // given
        let removalAction = sut.actionRepository.actions[1]
        
        // when
        sut.deleteAction(removalAction)
        let count = sut.actionRepository.actions.count
        
        XCTAssertEqual(count, 4)
    }
    
    func testActionListVM_loadPastActions_hasPastAction() {
        // given
        let pastCount = sut.previousActionCellViewModels.count
        
        // Get the current date set to yesterdayAlmostMidnight
        let date = Date().yesterday(.end)
        let actionDate = sut.actionRepository.actions[2].startDate
        
        // when

        
        // assert
        XCTAssertEqual(date, actionDate)
        XCTAssertEqual(pastCount, 1)
    }
    
    func testActionListVM_loadBaseDateActions_hasBaseDateAction() {
        // given
        let currentCount = sut.baseDateActionCellViewModels.count
        
        // when
        
        // assert
        XCTAssertEqual(currentCount, 2)
    }
    

    func testActionListVM_loadWeekActions_hasWeekAction() {
        // given
        // Need to design this one.
        let currentCount = sut.baseDateWeekActionCellViewModels.count
        // let actionTitle: String = sut.baseDateWeekActionCellViewModels[0].action.title
        
        // when

        // assert
        if sut.baseDate == sut.baseDate.endOfWeekDate(timeOfDay: .start) {
            XCTAssertEqual(currentCount, 1)
        } else {
            XCTAssertEqual(currentCount, 0)
        }
        // XCTAssertEqual(actionTitle, "Action for beginning of next week")
    }

    
    func testActionListVM_loadFutureActions_hasFutureAction() {
        // given
        // Need to design this one too.
        let currentCount = sut.futureActionCellViewModels.count
        
        // when
        
        // assert
        if sut.baseDate == sut.baseDate.endOfWeekDate(timeOfDay: .start) {
            XCTAssertEqual(currentCount, 1)
        } else {
            XCTAssertEqual(currentCount, 2)
        }
    }
}
