//
//  HomeView.swift
//  GoalTogether
//
//  Created by Charlie Page on 4/4/21.
//

import SwiftUI

struct HomeView: View {
    @StateObject var actionListVM = ActionListViewModel()
    @StateObject var seasonAimsVM = SeasonAimsViewModel()
    
    @State var selection = 0
    
    var body: some View {
        TabView(selection: $selection) {
            HomePage(actionListVM: actionListVM)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            SeasonView(seasonAimsVM: seasonAimsVM)
                .tabItem {
                    Label("Season", systemImage: "scribble.variable")
                }
                .tag(1)
            GroupsPage()
                .tabItem {
                    Label("Groups", systemImage: "person.2.fill")
                }
                .tag(2)
            FriendsPage()
                .tabItem {
                    Label("Friends", systemImage: "person.crop.circle.badge.plus")
                }
                .tag(3)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
