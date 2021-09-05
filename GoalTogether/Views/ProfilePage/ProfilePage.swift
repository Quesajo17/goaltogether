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
    
    @State private var showImagePicker = false
    
    var cancellable = Set<AnyCancellable>()
    

    
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
                            TextField("First Name", text: $userProfileVM.editingProfile.firstName ?? "")
                            TextField("Last Name", text: $userProfileVM.editingProfile.lastName ?? "")
                            TextField("email", text: $userProfileVM.editingProfile.email ?? "")
                        }
                        Section() {
                            HStack {
                                Spacer()
                                Button(action: {
                                    AuthenticationState.shared.signout()
                                    presentationMode.wrappedValue.dismiss()
                                }, label: {
                                    Text("Sign Out")
                                })
                                Spacer()
                            }
                        }
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
        userProfileVM.saveEditingProfile()
        
        if userProfileVM.selectedImage != nil {
            userProfileVM.originalProfile.saveImagetoFirebase(image: userProfileVM.selectedImage!)
        }
        presentationMode.wrappedValue.dismiss()
    }
}

struct ProfilePage_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePage()
    }
}
