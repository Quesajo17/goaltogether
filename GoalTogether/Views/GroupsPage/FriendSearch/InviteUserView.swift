//
//  InviteUserView.swift
//  GoalTogether
//
//  Created by Charlie Page on 7/17/21.
//

import SwiftUI

struct InviteUserView: View {
    
    @ObservedObject var userSearchVM: UserSearchViewModel
    @ObservedObject var userCellVM: UserCellViewModel
    @Binding var showUserInviteView: Bool
    
    var body: some View {
        VStack {
            AnyUserProfileImage()
                .environmentObject(userCellVM)
            Text(userCellVM.name ?? "No Name")
            if userCellVM.user.email != nil {
                Text(userCellVM.user.email!)
            }
            Button(action: {
                self.showUserInviteView.toggle()
                self.userSearchVM.save(user: userCellVM.user)
                     }, label: { Text("Invite to Group")
                
            })
        }
    }
}

struct InviteUserView_Previews: PreviewProvider {
    static var previews: some View {
        InviteUserView(
            userSearchVM: UserSearchViewModel(userRepository: UserSearchRepository(), saveCallback: { user in
                       print(user.firstName ?? "Test")
                   }),
            userCellVM: UserCellViewModel(user: UserProfile(id: nil, firstName: "Charlie", lastName: "Page", email: "charles.david.page@gmail.com", phoneNumber: nil, birthday: nil, profileImagePhoto: nil, summary: nil, defaultSeason: nil, seasonLength: nil, groupMembership: nil)),
            showUserInviteView: .constant(false))
    }
}
