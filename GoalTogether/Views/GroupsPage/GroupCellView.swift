//
//  GroupCellView.swift
//  GoalTogether
//
//  Created by Charlie Page on 9/2/21.
//

import SwiftUI

struct GroupCellView: View {
    @ObservedObject var groupCellVM: GroupCellViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text(groupCellVM.group.title != nil ? groupCellVM.group.title! : "Group has No Name")
                    .fontWeight(.bold)
                    .foregroundColor(Color.black)
                    .padding(.leading, 5)
                    .padding(.bottom, 1)
                Spacer()
            }
            if groupCellVM.group.description != nil {
                HStack {
                    Text(groupCellVM.group.description!)
                        .foregroundColor(Color.black)
                        .padding(.leading, 5)
                        .padding(.trailing, 5)
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                }
            }
        }.padding()
        .background(Color.gray.cornerRadius(8)).opacity(0.7)
        // .background(RoundedRectangle(cornerRadius: 8)
                        // .foregroundColor(Color.gray))
    }
}

struct GroupCellView_Previews: PreviewProvider {
    static var previews: some View {
        GroupCellView(groupCellVM: GroupCellViewModel(groupRepository: MyGroupsRepository(), accountabilityGroup: AccountabilityGroup(id: "test1", title: "Mastermind Group", description: "This is a group of several friends who all want to keep people accountable", creationDate: Date(), activeMembers: [String](), pendingMembers: [String]())))
    }
}
