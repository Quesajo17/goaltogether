//
//  PendingGroupInviteView.swift
//  GoalTogether
//
//  Created by Charlie Page on 10/5/21.
//

import SwiftUI

struct PendingGroupInviteView: View {
    
    @StateObject var singleGroupVM: SingleGroupViewModel
    
    var onAcceptDecline = {}
    
    var body: some View {
        VStack {
            Text(singleGroupVM.group.title!)
                .font(.largeTitle)
                .fontWeight(.bold)
            if singleGroupVM.group.description != nil {
                Text(singleGroupVM.group.description!)
            }
            ForEach(singleGroupVM.activeUserCellVMs) { activeUserCellVM in
                MemberCellView(userCellVM: UserCellViewModel(user: activeUserCellVM.user))
            }
            HStack {
                Button(action: {
                    do {
                        try singleGroupVM.acceptGroupInvitation()
                    } catch {
                        print(error.localizedDescription)
                    }
                    self.onAcceptDecline()
                }){
                    Text("Join Group")
                }.buttonStyle(RoundedRectangleBlackButtonStyle())
                .padding()
                Button(action: {
                    do {
                        try singleGroupVM.declineGroupInvitation()
                    } catch {
                        print(error.localizedDescription)
                    }
                    self.onAcceptDecline()
                }){
                    Text("Decline")
                }.buttonStyle(RoundedRectangleBlackButtonStyle())
                .padding()
            }
        }
    }
}

struct PendingGroupInviteView_Previews: PreviewProvider {
    static var previews: some View {
        PendingGroupInviteView(singleGroupVM: SingleGroupViewModel(groupRepository: MyGroupsRepository(), groupUserRepository: GroupMemberUserRepository(), group: AccountabilityGroup(id: "newgroup", title: "Test Group", description: "String", creationDate: Date(), activeMembers: ["member1"], pendingMembers: nil)))
    }
}
