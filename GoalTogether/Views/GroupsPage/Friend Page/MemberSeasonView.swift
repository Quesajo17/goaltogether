//
//  MemberSeasonView.swift
//  GoalTogether
//
//  Created by Charlie Page on 9/21/21.
//

import SwiftUI

struct MemberSeasonView: View {
    
    @ObservedObject var activeMemberVM: ActiveMemberViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text(activeMemberVM.seasonTitle != nil ? activeMemberVM.seasonTitle! : "Untitled Season")
                        .font(.largeTitle)
                    Spacer()
                }
                if activeMemberVM.completedAimViewModels.count > 0 {
                    HStack {
                        Text("Completed")
                            .font(.largeTitle)
                        Spacer()
                    }
                    ForEach(activeMemberVM.completedAimViewModels) { aimVM in
                        MemberAimCell(aimCellVM: aimVM)
                            .padding()
                    }
                }
                if activeMemberVM.incompleteAimViewModels.count > 0 {
                    HStack {
                        Text("Outstanding")
                            .font(.largeTitle)
                        Spacer()
                    }
                    ForEach(activeMemberVM.incompleteAimViewModels) { aimVM in
                        MemberAimCell(aimCellVM: aimVM)
                            .padding()
                    }
                }
            }
        }
    }
}

struct MemberSeasonView_Previews: PreviewProvider {
    static var previews: some View {
        MemberSeasonView(activeMemberVM: ActiveMemberViewModel(friendAimsRepository: FriendAimAndActionRepository(user: CurrentUserProfile.shared.currentUser!), user: CurrentUserProfile.shared.currentUser!))
    }
}
