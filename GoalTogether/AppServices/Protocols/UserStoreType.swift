//
//  UserStoreType.swift
//  GoalTogether
//
//  Created by Charlie Page on 7/9/21.
//

import Foundation

protocol UserStoreType {
    var users: [UserProfile] { get set }
    var usersPublished: Published<[UserProfile]> { get }
    var usersPublisher: Published<[UserProfile]>.Publisher { get }
    
    func loadUsers()
    func endListening()
}


