//
//  AimAndActionStoreType.swift
//  GoalTogether
//
//  Created by Charlie Page on 9/19/21.
//

import Foundation

protocol AimAndActionStoreType {
    
    var user: UserProfile { get set }
    var startDate: Date { get set }
    var endDate: Date { get set }
    
    var actions: [Action] { get set }
    var actionsPublished: Published<[Action]> { get }
    var actionsPublisher: Published<[Action]>.Publisher { get }
    
    var aims: [Aim] { get set }
    var aimsPublished: Published<[Aim]> { get }
    var aimsPublisher: Published<[Aim]>.Publisher { get }
    
    var seasonTitle: String? { get set }
    var seasonTitlePublished: Published<String?> { get }
    var seasonTitlePublisher: Published<String?>.Publisher { get }
    
    func loadActions() throws
    func loadAims() throws
    func loadSeasonTitle()
}
