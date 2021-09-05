//
//  SeasonStoreType.swift
//  GoalTogether
//
//  Created by Charlie Page on 5/22/21.
//


import Foundation
import Combine

protocol SeasonStoreType {
    
    var currentSeason: Season? { get set }
    var currentSeasonPublished: Published<Season?> { get }
    var currentSeasonPublisher: Published<Season?>.Publisher { get }
    
    var seasonList: [Season] { get set }
    var seasonListPublished: Published<[Season]> { get }
    var seasonListPublisher: Published<[Season]>.Publisher { get }
    
    
    func loadOrCreateCurrentSeason()
    func loadMostRecentSeason() -> Future<Season, ErrorLoadingSeason>
}
