//
//  MemberAimCell.swift
//  GoalTogether
//
//  Created by Charlie Page on 9/22/21.
//

import SwiftUI

struct MemberAimCell: View {
    
    @ObservedObject var aimCellVM: ActiveMemberAimCellViewModel
    @State var expandedView: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    HStack {
                        Text(aimCellVM.aim.title)
                            .fontWeight(.bold)
                            .padding(.leading, 5)
                            .padding(.bottom, 1)
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                    }
                    if aimCellVM.aim.description != nil {
                        Text(aimCellVM.aim.description!)
                            .padding(.leading, 5)
                            .padding(.trailing, 5)
                            .padding(.bottom, 5)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                VStack {
                    Image(systemName: expandedView == false ? "chevron.down.circle" : "chevron.up.circle")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding()
                        .onTapGesture {
                            self.expandedView.toggle()
                            if expandedView == true {
                                self.aimCellVM.loadAimDetails()
                            }
                        }
                }.padding(.top)
                .padding(.bottom)
            }
            if expandedView == true && aimCellVM.actions != nil {
                Text("Actions")
                    .font(.subheadline)
                ForEach(aimCellVM.actions!) { action in
                    AimActionSubCell(action: action)
                        .padding()
                }
            }
        }.background(RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(aimCellVM.aim.completed ? Color.green : Color.gray))
    }
}

struct MemberAimCell_Previews: PreviewProvider {
    static var previews: some View {
        MemberAimCell(aimCellVM: ActiveMemberAimCellViewModel(aim: Aim(id: nil, title: "Original Goal", userId: nil, seasonId: "newSeasonId", startDate: Date(), plannedEndDate: Date(), completed: false, completionDate: nil, description: "This is my first long term goal. We'll see if I'm able to accomplish it effectively.", actions: nil), userProfile: CurrentUserProfile.shared.currentUser!))
    }
}
