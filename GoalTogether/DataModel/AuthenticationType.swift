//
//  AuthenticationType.swift
//  GoalTogether
//
//  Created by Charlie Page on 4/5/21.
//

import Foundation

enum AuthenticationType: String {
    case login
    case signup
    
    var text: String {
        rawValue.capitalized
    }
    
    var assetBackgroundName: String {
        self == .login ? "login" : "signup"
    }
    
    var footerText: String {
        switch self {
            case .login:
                return "Not a member? Sign up."
            
        case .signup:
            return "Already a member? Log in."
        }
    }
}

extension NSError: Identifiable {
    public var id: Int { code }
}
