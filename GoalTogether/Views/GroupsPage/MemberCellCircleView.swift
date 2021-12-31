//
//  MemberCellCircleView.swift
//  GoalTogether
//
//  Created by Charlie Page on 10/1/21.
//

import SwiftUI

struct MemberCellCircleView: View {
    
    @ObservedObject var userCellVM: UserCellViewModel
    
    init(userCellVM: UserCellViewModel) {
        self.userCellVM = userCellVM
    }
    
    var body: some View {
        VStack {
            AnyUserProfileImage()
                .environmentObject(userCellVM)
            Text(userCellVM.name != nil ? userCellVM.name! : "No Name")
        }
    }
}

struct MemberCellCircleView_Previews: PreviewProvider {
    static var previews: some View {
        MemberCellCircleView(userCellVM: UserCellViewModel(user: UserProfile(id: nil, firstName: "Charlie", lastName: "Page", email: "charles.david.page@gmail.com", phoneNumber: nil, birthday: nil, profileImagePhoto: nil, summary: nil, defaultSeason: nil, seasonLength: nil, groupMembership: nil)))
    }
}
