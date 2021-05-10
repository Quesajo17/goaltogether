//
//  GoalTogetherApp.swift
//  GoalTogether
//
//  Created by Charlie Page on 4/3/21.
//

import SwiftUI
import Firebase

@main
struct GoalTogetherApp: App {

    let authState: AuthenticationState
    let userProfile: CurrentUserProfile
    
    init() {
        FirebaseApp.configure()
        self.authState = AuthenticationState.shared
        self.userProfile = CurrentUserProfile.shared
    }
 
 
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authState)
                .environmentObject(userProfile)
        }
    }
}

private extension GoalTogetherApp {
    func setupFirebase() {
        // FirebaseApp.configure()
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously()
        }
        print("User ID is: \(String(describing: Auth.auth().currentUser?.uid))")
    }
}
