//
//  ActionStoreType.swift
//  GoalTogether
//
//  Created by Charlie Page on 4/3/21.
//

import Foundation

protocol ActionStoreType {
    
    // Note to self: We need the action, the action publisher, and the actions published in here. https://swiftsenpai.com/swift/define-protocol-with-published-property-wrapper/
    // Here is the basic Action Store group.
    var actions: [Action] { get set }
    // And the published value for actions.
    var actionsPublished: Published<[Action]> { get }
    // And the publisher itself.
    var actionsPublisher: Published<[Action]>.Publisher { get }
    
    func loadData()
    func addAction(_ action: Action)
    func updateAction(_ action: Action)
    func deleteAction(_ action: Action)
    func endListening()
}

protocol AimActionStoreType: ActionStoreType {
    
    var aim: Aim { get }
    
    init(aim: Aim)
    
}
