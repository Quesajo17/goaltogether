//
//  DateExtensions.swift
//  GoalTogether
//
//  Created by Charlie Page on 4/3/21.
//

import Foundation

// Functions used from this StackOverflow post: https://stackoverflow.com/questions/47223014/get-next-tuesday-and-thursday-from-current-date-in-swift

//Public Weekday enumeration
enum Weekday: String {
    case mon, tue, wed, thu, fri, sat, sun
}

fileprivate func endOfWeekDay(firstDay weekday: Weekday = .sun) -> Weekday {
    var lastDay: Weekday
    if weekday == .sun {
        lastDay = .sat
    } else if weekday == .mon {
        lastDay = .sun
    } else if weekday == .tue {
        lastDay = .mon
    } else if weekday == .wed {
        lastDay = .tue
    } else if weekday == .thu {
        lastDay = .wed
    } else if weekday == .fri {
        lastDay = .thu
    } else if weekday == .sat {
        lastDay = .fri
    } else {
        lastDay = .sat
    }
    return lastDay
}

extension Date {
    
    static func today() -> Date {
        return Date()
    }
    
    private func next(_ weekday: Weekday, considerToday: Bool = true) -> Date {
        return get(.next, weekday, considerToday: considerToday)
    }
    
    private func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.previous, weekday, considerToday: considerToday)
    }
    
    private func get(_ direction: SearchDirection, _ weekDay: Weekday, considerToday consider: Bool = false) -> Date {
        
        let dayName = weekDay.rawValue
        
        let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }
                assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")
        
        let searchWeekdayIndex = weekdaysName.firstIndex(of: dayName)! + 1
        
        let calendar = Calendar(identifier: .gregorian)
        
        if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
            return self
        }
        
        var nextDateComponent = calendar.dateComponents([.hour, .minute, .second], from: self)
        nextDateComponent.weekday = searchWeekdayIndex
        
        let date = calendar.nextDate(after: self, matching: nextDateComponent, matchingPolicy: .nextTime, direction: direction.calendarSearchDirection)
        
        return date!
        
    }
}


// MARK: Helper methods
private extension Date {
    private func getWeekDaysInEnglish() -> [String] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar.shortWeekdaySymbols
    }
    
    enum SearchDirection {
        case next
        case previous
        
        var calendarSearchDirection: Calendar.SearchDirection {
            switch self {
            case.next:
                return .forward
            case.previous:
                return .backward
            }
        }
    }
}


extension Date {
    
    enum TimeOfDay {
        case start
        case end
    }
    
    /// The dateStartOrEnd function accepts a TimeOfDay enumeration, for start or end, and returns either the start of the day 0000 hours, or one minute before midnight.
    ///
    /// - parameter timeOfDay: Accepts either the start or the end of the day as a parameter
    /// - returns: Either the start of the day, at 0000 hours, or one minute before midnight, depending on whether start or end is specified
    private func dateStartOrEnd(_ timeOfDay: TimeOfDay) -> Date {
        let referenceDate = self
        var newDate: Date
        switch timeOfDay {
        case .start:
            newDate = referenceDate.dateStart()
        case .end:
            newDate = referenceDate.dateEnd()
        }
        return newDate
    }
    
    /// The dateStart function returns the beginning of the currently referenced date.
    ///
    /// - returns: Beginning of the current date.
    func dateStart() -> Date {
        let referenceDate = self
        return Calendar.current.startOfDay(for: referenceDate)
    }
    
    /// The dateEnd function returns the time one minute before midnight on the currently referenced date.
    ///
    /// - returns: One minute before midnight on the currently referenced date.
    func dateEnd() -> Date {
        let referenceDateStart = Calendar.current.startOfDay(for: self)
        let tomorrowStart = Calendar.current.date(byAdding: .day, value: 1, to: referenceDateStart)
        let minuteComp = DateComponents(minute: -1)
        
        let todayAlmostMidnight = Calendar.current.date(byAdding: minuteComp, to: tomorrowStart!)
        return todayAlmostMidnight!
    }
    
    /// The tomorrowDate function returns tomorrow's date (by default, at the beginning of the day)
    ///
    /// - parameter timeOfDay: Parameter for determining whether this returns the start or the end of the day (default is start). Write as .start or .end
    /// - returns: Tomorrow's date
    func tomorrowDate(_ timeOfDay: TimeOfDay = .start) -> Date {
        let currentDate = self
        let tomorrowDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)
        guard tomorrowDate != nil else {
            print("Could not find the next date for \(currentDate)")
            return currentDate
        }
        
        let newDate = tomorrowDate!.dateStartOrEnd(timeOfDay)
        
        return newDate
    }
    
    /// The endOfWeekDate function takes a weekday that functions as the start of week. It returns the date of the end of the current week.
    ///
    /// - parameter weekStart: String parameter that accepts a weekday (IN PROGRESS).
    /// - parameter timeOfDay: Parameter for determining whether this returns the start or the end of the day (default is end). Write as .start or .end
    /// - returns: Date of the last day of the week.
    func endOfWeekDate(weekStart weekday: Weekday = .sun, timeOfDay: TimeOfDay = .end) -> Date {
        let weekEndDay = endOfWeekDay(firstDay: weekday)
        let weekEndDate = self.next(weekEndDay, considerToday: true)
        
        let newDate = weekEndDate.dateStartOrEnd(timeOfDay)
        return newDate
    }
    
    /*
    /// The getDays func pulls a list of days within a specific time range.
    ///
    /// - parameter firstDay: Date parameter for the first day of the range.
    /// - parameter lastDay: Date parameter for the last day of the range.
    /// - parameter includeFirstDay: Boolean parameter about whether to include the firstDay in the range that is returned. Default value is false.
    /// - parameter includeLastDay: Boolean parameter about whether to include the lastDay in the range that is returned. Default value is true.
    /// - returns: An array of dates between the first and last dates, optionally including or excluding those dates.
    func getDays(firstDate: Date, lastDate: Date, includeFirstDate: Bool = false, includeLastDate: Bool = true) -> [Date] {
        var dates = [Date]()
        var date = firstDate
        if includeFirstDate == true {
            dates.append(firstDate)
        }
        while date < lastDate {
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
            dates.append(date)
        }
        if includeLastDate == true {
            dates.append(lastDate)
        }
        return dates
    }
 */
    
    /// The yesterdayAlmostMidnight function takes a date, and returns the time one minute before midnight on the previous day.
    ///
    /// - parameter timeOfDay: Parameter for determining whether this returns the start or the end of the day (no default). Write as .start or .end
    /// - returns: A date one minute prior to midnight on the day before the reference date.
    func yesterday(_ timeOfDay: TimeOfDay) -> Date {
        let referenceDate = self
        let yesterdayDate = Calendar.current.date(byAdding: .day, value: -1, to: referenceDate)
        
        guard yesterdayDate != nil else {
            fatalError("Could not find yesterday")
        }
        
        let newDate = yesterdayDate!.dateStartOrEnd(timeOfDay)
        
        return newDate
    }
    
    /// The todayAlmostMidnight  function takes a date, and returns the time one minute before midnight on that date.
    ///
    /// - returns: A date one minute prior to midnight on the reference date.
    func todayAlmostMidnight() -> Date {
        let referenceDate = self.tomorrowDate()
        
        let minuteComp = DateComponents(minute: -1)
        let newDate = Calendar.current.date(byAdding: minuteComp, to: referenceDate)
        
        guard newDate != nil else {
            print("Could not find yesterday Almost Midnight")
            return referenceDate
        }
        
        return newDate!
    }
    
    /// The todayOrNextWeekStart function finds the first day that is NOT the end of the week, starting from a base date. It accepts an optional parameter for the end of the week, but otherwise uses the regular endOfWeek function to determine the last date of the week
    ///
    ///- parameter ends: The ends (lastDate) parameter is an optional parameter that accepts a date for the end of the week relative to the base date.
    ///
    ///- Returns: The currentDate, if it is not the last day of the week, or the day after the currentDate, if it is.
    func todayOrNextWeekStart(ends lastDate: Date? = nil) -> Date {
        let currentDate = self
        var endOfWeekDate: Date
        
        // Set the endOfWeek to the end of Week current date if there is no lastDate, and to the lastDate if there is one.
        if lastDate == nil {
            endOfWeekDate = currentDate.endOfWeekDate()
        } else {
            endOfWeekDate = lastDate!
        }
        
        // Return tomorrow from the baseDate if the currentDate is the end of the week, and return the current date if it's not the end of the week.
        if currentDate == endOfWeekDate {
            print("Current Date: \(currentDate) and endOfWeekDate: \(endOfWeekDate) are the same!")
            return currentDate.tomorrowDate()
        } else {
            print("The current date of \(currentDate) is not the end of the week (\(endOfWeekDate))")
            return currentDate
        }
    }
    
}


