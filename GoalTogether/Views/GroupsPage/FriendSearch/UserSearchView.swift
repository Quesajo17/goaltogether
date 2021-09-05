//
//  UserSearchView.swift
//  GoalTogether
//
//  Created by Charlie Page on 7/17/21.
//

import SwiftUI

struct UserSearchView: View {
    
    @ObservedObject var userSearchVM: UserSearchViewModel
    @Binding var showUserInviteView: Bool
    
    var body: some View {
        List {
            ForEach(userSearchVM.availableUsers) { userCellVM in
                NavigationLink(destination: InviteUserView(userSearchVM: userSearchVM, userCellVM: userCellVM, showUserInviteView: $showUserInviteView)) {
                    SearchPageUserCellView(userCellVM: userCellVM)
                }
            }
        }.navigationTitle("Invite New User")
    }
}

struct UserSearchView_Previews: PreviewProvider {
    static var previews: some View {
        UserSearchView(userSearchVM: UserSearchViewModel(userRepository: UserSearchRepository(), saveCallback: { user in
            print(user.firstName ?? "Test")
        }), showUserInviteView: .constant(false))
    }
}
