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
        HStack {
            AnyUserProfileImage()
                .environmentObject(userCellVM)
            VStack {
                HStack {
                    Text(userCellVM.name ?? "No Name")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.lightText)
                    Spacer()
                }
                if userCellVM.user.email != nil {
                    Text(userCellVM.user.email!)
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundColor(.lightText)
                }
            }
            Spacer()
        }.background(RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(Color.gray)
                        .opacity(0.7))
        .padding()
        .fixedSize(horizontal: false, vertical: true)

    }
}

struct MemberCellView_Previews: PreviewProvider {
    static var previews: some View {
        MemberCellView(userCellVM: UserCellViewModel(user: UserProfile(id: nil, firstName: "Charlie", lastName: "Page", email: "charles.david.page@gmail.com", phoneNumber: nil, birthday: nil, profileImagePhoto: nil, summary: nil, defaultSeason: nil, seasonLength: nil, groupMembership: nil)))
    }
}
