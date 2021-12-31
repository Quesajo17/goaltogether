//
//  GroupHubView.swift
//  GoalTogether
//
//  Created by Charlie Page on 9/4/21.
//

import SwiftUI

enum ActiveGroupHubSheet: Identifiable {
    case profilePage, newGroupPage, pendingGroupsPage
    
    var id: Int {
        hashValue
    }
}

struct GroupHubView: View {
    @StateObject var groupHubVM: GroupHubViewModel
    
    @State var activeSheet: ActiveGroupHubSheet?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    if groupHubVM.pendingInviteViewModels.count > 0 {
                        Button(action: {
                            self.activeSheet = .pendingGroupsPage
                        }) {
                            Text(groupHubVM.pendingInviteViewModels.count == 1 ? "You have been invited to a new group." : "You have been invited to new groups.")
                        }.buttonStyle(BorderlessButtonStyle())
                        .padding()
                    }
                    ForEach(groupHubVM.activeGroupViewModels) { groupCellVM in
                        NavigationLink(destination: SingleGroupView(singleGroupVM: SingleGroupViewModel(groupRepository: groupHubVM.groupRepository, groupUserRepository: GroupMemberUserRepository(), group: groupCellVM.group))) {
                            GroupCellView(groupCellVM: groupCellVM)
                                .padding()
                        }.buttonStyle(BorderlessButtonStyle())
                        
                    }
                    Button(action: {
                        self.activeSheet = .newGroupPage
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("Create New Group")
                        }
                    }.buttonStyle(RoundedRectangleBlackButtonStyle())
                    .padding()
                }
            }.sheet(item: $activeSheet, onDismiss: { self.activeSheet = nil }) { item in
                switch item {
                case .profilePage:
                    ProfilePage()
                case .newGroupPage:
                    NewGroupView(newGroupVM: NewGroupViewModel(groupRepository: self.groupHubVM.groupRepository, groupUserRepository: GroupMemberUserRepository()))
                case .pendingGroupsPage:
                    PendingGroupsSheet(groupHubVM: self.groupHubVM)
                }
            }
            .navigationBarItems(leading: Button(action: { self.activeSheet = .profilePage }) {
                Image(systemName: "person.circle")
                    .font(.system(size: 24))
            })
            .navigationBarTitle("My Groups", displayMode: .inline)
        }
    }
}

struct GroupHubView_Previews: PreviewProvider {
    static var previews: some View {
        GroupHubView(groupHubVM: GroupHubViewModel(groupRepository: MyGroupsRepository()))
    }
}
