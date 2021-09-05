//
//  NewGroupView.swift
//  GoalTogether
//
//  Created by Charlie Page on 7/14/21.
//

import SwiftUI

struct NewGroupView: View {
    
    @ObservedObject var newGroupVM: NewGroupViewModel
    
    @State var showUserInviteView: Bool = false
    @State private var showError: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Group Title")) {
                    TextField("Group Name", text: $newGroupVM.group.title ?? "")
                }
                
                Section(header: Text("Description")) {
                    ZStack {
                        TextEditor(text: $newGroupVM.group.description ?? "")
                        Text(newGroupVM.group.description ?? "")
                            .opacity(0)
                            .padding(.all, 8)
                    }
                }
                
                Section(header: Text("Members")) {
                    ScrollView(.horizontal, showsIndicators: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/, content: {
                        HStack {
                            ForEach(newGroupVM.pendingInviteeViewModels) { userCellVM in
                                MemberCellView(userCellVM: userCellVM)
                            }
                        }
                    })
                    Button(action: { self.showUserInviteView.toggle() }, label: { Text("Invite a New Member")
                    })
                }
            }
            .sheet(isPresented: $showUserInviteView) {
                NavigationView {
                    UserSearchView(userSearchVM: UserSearchViewModel(userRepository: UserSearchRepository(), saveCallback: { user in
                        do {
                            try newGroupVM.addUser(user)
                        } catch {
                            self.showError = true
                        }
                    }), showUserInviteView: $showUserInviteView)
                }
            }
            .alert(isPresented: $showError) {
                Alert(title: Text("Can't Invite User"),
                      message: Text("User is already added to this group."),
                      dismissButton: .default(Text("OK")))
            }
            .navigationBarTitle("Start a New Group")
            .navigationBarItems(leading: Button(action: { print("Cancel Changes") }) {
                Text("Cancel")
            },
            trailing: Button(action: {
                do {
                    try newGroupVM.saveGroup()
                } catch {
                    print("Could not save the group")
                }
                }) { Text("Save Changes")
                
            })
        }
    }
}

struct NewGroupView_Previews: PreviewProvider {
    static var previews: some View {
        NewGroupView(newGroupVM: NewGroupViewModel(groupRepository: MyGroupsRepository(), groupUserRepository: GroupMemberUserRepository()))
    }
}
