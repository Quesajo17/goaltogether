//
//  MockAimActionRepository.swift
//  GoalTogetherTests
//
//  Created by Charlie Page on 6/29/21.
//

import Foundation
import Combine
@testable import GoalTogether

class MockAimActionRepository: ObservableObject, AimActionStoreType {
    
    
    var db = TestActions()
    var aim: Aim
    
    @Published var actions: [Action] = [Action]()
    var actionsPublished: Published<[Action]> { _actions }
    var actionsPublisher: Published<[Action]>.Publisher { $actions }
    
    required init(aim: Aim) {
        self.aim = aim
    }
    
    func loadData() {
        let actionsList = db.actionsCollection
        
        let aimActions = actionsList.filter { action in
            return action.aimId == self.aim.id
        }
        
        self.actions = aimActions
    }
    
    func addAction(_ action: Action) {
        self.actions.append(action)
    }
    
    func updateAction(_ action: Action) {
        // play with this using the stack overflow question if needed - https://stackoverflow.com/questions/38084406/find-an-item-and-change-value-in-custom-object-array-swift
        // might need to set this separately, return the original function, set it equal to action, and then replace that item in the array. As the code below is erroring out.
        // Refer to this file as well: https://www.hackingwithswift.com/new-syntax-swift-2-error-handling-try-catch
        // Might need to put this in a do-catch block. I don't fully understand the difference between try? and try
        var actionList = self.actions
        let index = actionList.firstIndex(where: {$0.id == action.id})
        
        guard index != nil else {
            print("Could not find action to update")
            return
        }
        actionList[index!] = action
        
        self.actions = actionList
    }
    
    func deleteAction(_ action: Action) {
        var actionList = self.actions
        
        if let index = actionList.firstIndex(where: {$0.id == action.id}) {
            actionList.remove(at: index)
        }
        self.actions = actionList
    }
    
    func endListening() {
        // Stub
    }
    
    
}


