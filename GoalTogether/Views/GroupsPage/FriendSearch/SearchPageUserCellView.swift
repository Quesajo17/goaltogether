//
//  SearchPageUserCellView.swift
//  GoalTogether
//
//  Created by Charlie Page on 7/17/21.
//

import SwiftUI

struct SearchPageUserCellView: View {
    
    @ObservedObject var userCellVM: UserCellViewModel
    
    init(userCellVM: UserCellViewModel) {
        self.userCellVM = userCellVM
    }
    
    var body: some View {
        HStack {
            AnyUserProfileImage()
                .environmentObject(userCellVM)
            VStack {
                Text(userCellVM.name ?? "No Name")
                if userCellVM.user.email != nil {
                    Text(userCellVM.user.email!)
                }
            }
        }
    }
}

struct UserCellSearch_Previews: PreviewProvider {
    static var previews: some View {
        SearchPageUserCellView(userCellVM: UserCellViewModel(user: UserProfile(id: nil, firstName: "Charlie", lastName: "Page", email: "charles.david.page@gmail.com", phoneNumber: nil, birthday: nil, profileImagePhoto: nil, summary: nil, defaultSeason: nil, seasonLength: nil, groupMembership: nil)))
    }
}
