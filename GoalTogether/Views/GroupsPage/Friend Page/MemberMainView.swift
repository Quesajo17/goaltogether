//
//  MemberMainView.swift
//  GoalTogether
//
//  Created by Charlie Page on 9/11/21.
//

import SwiftUI

public enum MemberViewType: String {
    case week, season
}

struct MemberMainView: View {
    
    @StateObject var activeMemberVM: ActiveMemberViewModel
    
    @State private var viewType = 1
    
    var body: some View {
        VStack {
            Picker("Level of Detail", selection: $viewType, content: {
                Text("Week").tag(1)
                Text("Season").tag(2)
            }).pickerStyle(SegmentedPickerStyle())
            .onChange(of: viewType) { tag in
                if tag == 2 && activeMemberVM.aimsLoaded == false {
                    activeMemberVM.loadIncompleteAims()
                    activeMemberVM.loadCompletedAims()
                }
            }
            ScrollView {
                if viewType == 1 {
                    MemberWeekView(activeMemberVM: activeMemberVM)
                } else if viewType == 2 {
                    MemberSeasonView(activeMemberVM: activeMemberVM)
                }
            }
        }.navigationBarTitle(activeMemberVM.userName)

    }
}

struct MemberMainView_Previews: PreviewProvider {
    static var previews: some View {
        MemberMainView(activeMemberVM: ActiveMemberViewModel(friendAimsRepository: FriendAimAndActionRepository(user: CurrentUserProfile.shared.currentUser!), user: CurrentUserProfile.shared.currentUser!))
    }
}
