//
//  MemberWeekView.swift
//  GoalTogether
//
//  Created by Charlie Page on 9/21/21.
//

import SwiftUI

struct MemberWeekView: View {
    
    @ObservedObject var activeMemberVM: ActiveMemberViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text("\(activeMemberVM.friendAimsRepository.startDate, style: .date) - \(activeMemberVM.friendAimsRepository.endDate, style: .date)")
                        .font(.largeTitle)
                }
                ForEach(activeMemberVM.actions) { actionCellVM in
                    MemberActionCell(actionCellVM: actionCellVM)
                }
            }
        }
    }
}

struct MemberWeekView_Previews: PreviewProvider {
    static var previews: some View {
        MemberWeekView(activeMemberVM: ActiveMemberViewModel(friendAimsRepository: FriendAimAndActionRepository(user: CurrentUserProfile.shared.currentUser!), user: CurrentUserProfile.shared.currentUser!))
    }
}
