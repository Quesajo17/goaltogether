//
//  ProfilePage.swift
//  GoalTogether
//
//  Created by Charlie Page on 4/3/21.
//

import SwiftUI
import Combine

struct ProfilePage: View {
    @ObservedObject var userProfileVM = UserProfileViewModel()
    
    @Environment(\.presentationMode) private var presentationMode
    
    @State var userProfile: UserProfile?
    
    @State var originalImage: UIImage?
    @State var selectedImage: UIImage?
    
    @State var email: String = ""
    @State var firstName: String = ""
    @State var lastName: String = ""
    
    @State private var showImagePicker = false
    
    var cancellable = Set<AnyCancellable>()
    
    init() {
        
        userProfileVM.$userProfile
            .print()
            .assign(to: \.userProfile, on: self)
            .store(in: &cancellable)
             
    }
    
    var body: some View {
        NavigationView {
                    Form {
                        Section() {
                            ProfileImage()
                                .environmentObject(userProfileVM)
                                .onTapGesture {
                                    self.showImagePicker = true
                                }
                        }.listRowBackground(Color(UIColor.systemGroupedBackground))
                        Section(header: Text("Details")) {
                            TextField("First Name", text: $firstName)
                            TextField("Last Name", text: $lastName)
                            TextField("email", text: $email)
                        }
                        Section() {
                            HStack {
                                Spacer()
                                Button(action: {
                                    AuthenticationState.shared.signout()
                                }, label: {
                                    Text("Sign Out")
                                })
                                Spacer()
                            }
                        }
                    }.onAppear {
                        email = userProfileVM.userProfile?.email ?? ""
                        firstName = userProfileVM.userProfile?.firstName ?? ""
                        lastName = userProfileVM.userProfile?.lastName ?? ""
                    }
                .navigationBarTitle("Your Profile")
                .navigationBarItems(leading: Button(action: { cancelChanges() }) {
                    Text("Cancel")
                        .sheet(isPresented: $showImagePicker) {
                            ImagePicker(sourceType: .photoLibrary, selectedImage: $userProfileVM.selectedImage)
                        }
                },
                trailing: Button(action: { saveChanges() }) { Text("Save Changes")
            })
        }
    }
    
    func cancelChanges() {
        presentationMode.wrappedValue.dismiss()
    }
    
    func saveChanges() {
        var userProfile = UserProfile(id: userProfileVM.userProfile!.id, firstName: self.firstName, lastName: self.lastName, email: self.email)
        
        if userProfileVM.selectedImage != nil {
            userProfileVM.saveImagetoFirebase(image: userProfileVM.selectedImage!)
            
            
            //need to figure out how to make this wait until the other stuff is finished.
            userProfile.profileImagePhoto = userProfileVM.userProfile?.profileImagePhoto
        }
        
        print("user's profile image is \(userProfile.profileImagePhoto)")
        userProfileVM.updateUser(userProfile)
        presentationMode.wrappedValue.dismiss()
    }
}

struct ProfilePage_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePage()
    }
}
