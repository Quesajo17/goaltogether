//
//  ContentView.swift
//  GoalTogether
//
//  Created by Charlie Page on 4/3/21.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var authState: AuthenticationState
    @EnvironmentObject var userProfile: CurrentUserProfile
    
    private func signoutTapped() {
        authState.signout()
    }
    
    var body: some View {
        Group {
            if authState.loggedInUser != nil && userProfile.currentUser != nil {
                HomeView()
            } else {
                AuthenticationView(authType: .login)
            }
        }
        .animation(.easeInOut)
        .transition(.move(edge: .bottom))
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
