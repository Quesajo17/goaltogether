//
//  AimStoreType.swift
//  GoalTogether
//
//  Created by Charlie Page on 5/18/21.
//

import Foundation

protocol AimStoreType {
    
    var season: Season? { get set }
    
    var aims: [Aim] { get set }
    var aimsPublished: Published<[Aim]> { get }
    var aimsPublisher: Published<[Aim]>.Publisher { get }
    
    func loadData()
    func loadDetails(_ aim: Aim)
    func addAim(_ aim: Aim)
    func updateAim(_ aim: Aim)
    func deleteAim(_ aim: Aim)
    func endListening()
}
