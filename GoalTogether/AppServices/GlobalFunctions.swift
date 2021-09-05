//
//  GlobalFunctions.swift
//  GoalTogether
//
//  Created by Charlie Page on 5/10/21.
//

import Foundation
import SwiftUI

public func ??<T>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}

/*
func assertEqual(lhs: String, rhs: String) -> Bool {
    guard lhs != nil else { return false }
    guard rhs != nil else { return false }
    guard lhs == rhs else { return false }
}
 
*/
