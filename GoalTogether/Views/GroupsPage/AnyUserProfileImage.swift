//
//  AnyUserProfileImage.swift
//  GoalTogether
//
//  Created by Charlie Page on 7/15/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct AnyUserProfileImage: View {
    @EnvironmentObject private var userCellVM: UserCellViewModel
    
    var body: some View {
        HStack {
            Spacer()
            if userCellVM.imageURL != "" {
                WebImage(url: URL(string: userCellVM.imageURL))
                    .placeholder(Image(systemName: "person.fill"))
                    .resizable()
                    .scaledToFill()
                    .foregroundColor(.white)
                    .font(.system(size: 60))
                    .frame(width: 100, height: 100)
                    .background(Color.gray)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.black, lineWidth: 2))
                    .shadow(radius: 7)
                    .padding()
            } else {
                Image(systemName: "person.fill").foregroundColor(.white)
                    .font(.system(size: 60))
                    .frame(width: 100, height: 100)
                    .background(Color.gray)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.black, lineWidth: 2))
                    .shadow(radius: 7)
                    .padding()
            }
            Spacer()
        }
    }
}

struct AnyUserProfileImage_Previews: PreviewProvider {
    static var previews: some View {
        AnyUserProfileImage()
    }
}
