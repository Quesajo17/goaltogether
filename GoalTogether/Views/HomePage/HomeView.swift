//
//  HomeView.swift
//  GoalTogether
//
//  Created by Charlie Page on 4/4/21.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView {
            HomePage()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            SeasonPage()
                .tabItem {
                    Label("Season", systemImage: "scribble.variable")
                }
            GroupsPage()
                .tabItem {
                    Label("Groups", systemImage: "person.2.fill")
                }
            FriendsPage()
                .tabItem {
                    Label("Friends", systemImage: "person.crop.circle.badge.plus")
                }
            ProfilePage()
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
