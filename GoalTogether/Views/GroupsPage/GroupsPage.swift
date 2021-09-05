//
//  GroupsPage.swift
//  GoalTogether
//
//  Created by Charlie Page on 4/3/21.
//

import SwiftUI

struct GroupsPage: View {
    var body: some View {
        GroupHubView(groupHubVM: GroupHubViewModel(groupRepository: MyGroupsRepository()))
    }
}

struct GroupsPage_Previews: PreviewProvider {
    static var previews: some View {
        GroupsPage()
    }
}
