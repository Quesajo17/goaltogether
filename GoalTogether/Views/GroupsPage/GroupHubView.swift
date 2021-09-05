//
//  GroupHubView.swift
//  GoalTogether
//
//  Created by Charlie Page on 9/4/21.
//

import SwiftUI

struct GroupHubView: View {
    @ObservedObject var groupHubVM: GroupHubViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ForEach(groupHubVM.activeGroupViewModels) { groupCellVM in
                        GroupCellView(groupCellVM: groupCellVM)
                    }
                }
            }
        }
        

        /* Button() NewGroupView(newGroupVM: NewGroupViewModel(groupRepository: MyGroupsRepository(), groupUserRepository: GroupMemberUserRepository()))
 */
    }
}

struct GroupHubView_Previews: PreviewProvider {
    static var previews: some View {
        GroupHubView(groupHubVM: GroupHubViewModel(groupRepository: MyGroupsRepository()))
    }
}
