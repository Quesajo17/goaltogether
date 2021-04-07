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
    
    init() {
        FirebaseApp.configure()
        self.authState = AuthenticationState.shared
        
        setupFirebase()
    }
 
 
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authState)
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
