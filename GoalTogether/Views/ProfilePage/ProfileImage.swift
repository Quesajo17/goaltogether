//
//  ProfileImage.swift
//  GoalTogether
//
//  Created by Charlie Page on 4/26/21.
//

import SwiftUI

struct ProfileImage: View {
    @EnvironmentObject private var userProfileVM: UserProfileViewModel
    
    var body: some View {
        HStack {
            Spacer()
            if userProfileVM.selectedImage != nil {
                Image(uiImage: userProfileVM.selectedImage!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.black, lineWidth: 4))
                    .overlay(
                        CircleOverlay()
                    )
                    .shadow(radius: 7)
                    .padding()
            } else if userProfileVM.originalImage != nil {
                Image(uiImage: userProfileVM.originalImage!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.black, lineWidth: 4))
                    .overlay(
                        CircleOverlay()
                    )
                    .shadow(radius: 7)
                    .padding()
            } else {
                Image(systemName: "person.fill").foregroundColor(.white)
                    .font(.system(size: 60))
                    .frame(width: 100, height: 100)
                    .background(Color.gray)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.black, lineWidth: 2))
                    .overlay(
                        CircleOverlay()
                    )
                    .shadow(radius: 7)
                    .padding()
            }
            Spacer()
        }

    }
}

struct CircleOverlay: View {
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: 0.3)
                .foregroundColor(.black)
                .rotationEffect(.degrees(36))
                .overlay(Text("EDIT").foregroundColor(.white).font(.system(size: 10)).padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0)), alignment: .bottom)
        }
    }
}


struct ProfileImage_Previews: PreviewProvider {
    static var previews: some View {
        ProfileImage()
    }
}
