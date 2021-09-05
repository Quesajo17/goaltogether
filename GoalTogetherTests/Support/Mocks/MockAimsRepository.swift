//
//  MockAimsRepository.swift
//  GoalTogetherTests
//
//  Created by Charlie Page on 5/18/21.
//

import Foundation
@testable import GoalTogether

class MockAimsRepository: ObservableObject, AimStoreType {
    
    var db: TestAims?
    @Published var aims: [Aim] = [Aim]()
    var aimsPublished: Published<[Aim]> { _aims }
    var aimsPublisher: Published<[Aim]>.Publisher { $aims }
    
    var season: Season? {
        didSet {
            guard season != nil else {
                return
            }
            
            guard aims.count == 0 else {
                print("Data already loaded. Skipping")
                return
            }
            
            self.db = TestAims(season: season!)
            
            loadData()
        }
    }
    
    
    func loadData() {
        guard db != nil else {
            fatalError("about to try to loadData with no TestAims")
        }
        
        let aimList = db!.aimsCollection
        
        guard season != nil else {
            fatalError("loading aims without Season")
        }
        
        for aim in aimList {
            if aim.seasonId == self.season!.id {
                aims.append(aim)
                print("Adding this aim \(String(describing: aim.id)) with matching id of \(String(describing: self.season!.id))")
            } else {
                print("Aim with season \(aim.seasonId) is not equal to \(String(describing: self.season!.id))")
            }
        }
        NotificationCenter.default.post(name: .MockAimsRepositoryAimsLoaded, object: nil)
    }
    
    func loadDetails(_ aim: Aim) {
        print("Load Details")
    }
    
    func addAim(_ aim: Aim) {
        self.aims.append(aim)
    }
    
    func updateAim(_ aim: Aim) {
        var aimList = self.aims
        let index = aimList.firstIndex(where: {$0.id == aim.id})
        
        guard index != nil else {
            print("Could not find aim to update")
            return
        }
        aimList[index!] = aim
        
        self.aims = aimList
    }
    
    func deleteAim(_ aim: Aim) {
        var aimList = self.aims
        if let index = aimList.firstIndex(where: {$0.id == aim.id}) {
            aimList.remove(at: index)
        }
        self.aims = aimList
    }
    
    func endListening() {
        print("end Listening")
    }
}

public extension Notification.Name {
    static let MockAimsRepositoryAimsLoaded = Notification.Name(rawValue: "MockAimsRepositoryAimsLoaded")
}
