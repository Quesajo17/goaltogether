//
//  MemberCellView.swift
//  GoalTogether
//
//  Created by Charlie Page on 7/15/21.
//

import SwiftUI

struct MemberCellView: View {
    
    @ObservedObject var userCellVM: UserCellViewModel
    
    init(userCellVM: UserCellViewModel) {
        self.userCellVM = userCellVM
    }
    
    var body: some View {
        VStack {
            AnyUserProfileImage()
                .environmentObject(userCellVM)
            Text(userCellVM.user.firstName!)
        }
    }
}

struct MemberCellView_Previews: PreviewProvider {
    static var previews: some View {
        MemberCellView(userCellVM: UserCellViewModel(user: UserProfile(id: nil, firstName: "Charlie", lastName: "Page", email: "charles.david.page@gmail.com", phoneNumber: nil, birthday: nil, profileImagePhoto: nil, summary: nil, defaultSeason: nil, seasonLength: nil, groupMembership: nil)))
    }
}
