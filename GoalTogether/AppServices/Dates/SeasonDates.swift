//
//  SeasonDates.swift
//  GoalTogether
//
//  Created by Charlie Page on 5/19/21.
//

import Foundation

class SeasonDates {
    var seasonStart: Date
    var seasonEnd: Date
    var userProfile: UserProfile
    
    init(userProfile: UserProfile) {
        self.userProfile = userProfile
        self.seasonStart = Date().startOfPeriod(self.userProfile.seasonLength ?? .quarter)
        self.seasonEnd = Date().endOfPeriod(self.userProfile.seasonLength ?? .quarter)
    }
}

/*
// This extension of date contains code for calculating the start and end of a period, currently quarterly or monthly.
extension Date {
    
    /// The startOfPeriod function accepts a SeasonLength and calculates the start of that period based on the baseDate listed.
    ///
    /// - parameter seasonLength: This parameter (unlabeled) accepts a seasonLength value (quarter or month)
    /// - returns: Returns the start of the period based on the seasonLength and the base date.
    func startOfPeriod(_ seasonLength: SeasonLength) -> Date {
        let referenceDate = self
        var newDate: Date
        
        switch seasonLength {
        case .month:
            newDate = referenceDate.startOfMonth()
        case .quarter:
            newDate = referenceDate.startOfQuarter()
        }
        return newDate
    }
    
    /// The endOfPeriod function accepts a SeasonLength and calculates the end of that period based on the baseDate listed.
    ///
    /// - parameter seasonLength: This parameter (unlabeled) accepts a seasonLength value (quarter or month)
    /// - returns: Returns the end of the period based on the seasonLength and the base date.
    func endOfPeriod(_ seasonLength: SeasonLength) -> Date {
        let referenceDate = self
        var newDate: Date
        
        switch seasonLength {
        case .month:
            newDate = referenceDate.endOfMonth()
        case .quarter:
            newDate = referenceDate.endOfQuarter()
        }
        return newDate
    }
    
    private func startOfQuarter() -> Date {
        let referenceDate = self
        var components = Calendar.current.dateComponents([.year, .month], from: referenceDate)
        
        let quarterMonth: Int
        switch components.month! {
        case 1, 2, 3: quarterMonth = 1
        case 4, 5, 6: quarterMonth = 4
        case 7, 8, 9: quarterMonth = 7
        case 10, 11, 12: quarterMonth = 10
        default: quarterMonth = 1
        }
        components.month = quarterMonth
        let newDate = Calendar.current.date(from: components)!
        
        
        return newDate
    }
    
    private func endOfQuarter() -> Date {
        let referenceDate = self
        var components = Calendar.current.dateComponents([.year, .month], from: referenceDate)
        
        let quarterMonth: Int
        switch components.month! {
        case 1, 2, 3: quarterMonth = 4
        case 4, 5, 6: quarterMonth = 7
        case 7, 8, 9: quarterMonth = 10
        case 10, 11, 12:
            quarterMonth = 1
            components.year = (components.year ?? 0) + 1
        default: quarterMonth = 1
        }
        components.month = quarterMonth
        components.minute = (components.minute ?? 0) + 1
        
        let newDate = Calendar.current.date(from: components)!
        
        return newDate
    }
    
    private func startOfMonth() -> Date {
        let referenceDate = self
        let components = Calendar.current.dateComponents([.year, .month], from: referenceDate)
        let newDate = Calendar.current.date(from: components)!
        
        return newDate
    }
    
    private func endOfMonth() -> Date {
        let referenceDate = self
        var components = Calendar.current.dateComponents([.year, .month], from: referenceDate)
        // add one to the current month, and then subtract one minute
        components.month = (components.month ?? 0) + 1
        components.minute = (components.minute ?? 0) - 1
        let newDate = Calendar.current.date(from: components)!
        
        return newDate
    }
}

 */
