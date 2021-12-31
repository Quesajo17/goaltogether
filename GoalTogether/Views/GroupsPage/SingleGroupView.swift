//
//  SingleGroupView.swift
//  GoalTogether
//
//  Created by Charlie Page on 9/11/21.
//

import SwiftUI

struct SingleGroupView: View {
    
    @StateObject var singleGroupVM: SingleGroupViewModel
    
    @State var descriptionOpen: Bool = false
    
    @State var descriptionString: String
    
    @State var showUserInviteView: Bool = false
    @State private var showError: Bool = false
    
    init(singleGroupVM: SingleGroupViewModel) {
        _singleGroupVM = StateObject(wrappedValue: singleGroupVM)
        _descriptionString = State(initialValue: singleGroupVM.group.description != nil ? singleGroupVM.group.description! : "")
    }
    
    var body: some View {
        VStack {
            
            ScrollView(.vertical, showsIndicators: true, content: {
                VStack {
                    HStack {
                        Text("Description")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.leading)
                        Spacer()
                        Button(action: {
                            if descriptionOpen == false {
                                descriptionOpen.toggle()
                            } else {
                                if descriptionOpen == true {
                                    if singleGroupVM.group.description != descriptionString && descriptionString != "" {
                                        saveDescription()
                                    }
                                }
                            }
                        }) {
                            Image(systemName: descriptionOpen ? "square.and.arrow.down.fill" : "rectangle.and.pencil.and.ellipsis")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding(.trailing)
                        }
                    }
                    if descriptionOpen == false && descriptionString != "" {
                        HStack {
                            Text(descriptionString)
                                .padding()
                            Spacer()
                        }
                    } else if descriptionOpen == true {
                        TextEditor(text: $descriptionString)
                    }
                    HStack {
                        Text("Members")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.leading)
                        Spacer()
                    }
                    ForEach(singleGroupVM.activeUserCellVMs) { activeUserCellVM in
                        NavigationLink(destination:
                                        MemberMainView(activeMemberVM:
                                            ActiveMemberViewModel(
                                                friendAimsRepository: FriendAimAndActionRepository(user: activeUserCellVM.user),
                                                user: activeUserCellVM.user))) {
                            MemberCellView(userCellVM: activeUserCellVM)
                        }
                    }
                    Button(action: { self.showUserInviteView.toggle() }, label: { Text("Invite a New Member")
                    })
                }
            })
        }.sheet(isPresented: $showUserInviteView) {
            NavigationView {
                UserSearchView(userSearchVM: UserSearchViewModel(userRepository: UserSearchRepository(), saveCallback: { user in
                    do {
                        try singleGroupVM.inviteUser(user: user)
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
        .navigationBarTitle((singleGroupVM.group.title != nil ? singleGroupVM.group.title! : "Group has No Name"))
    }
    
    func editDescription() {
        
    }
    
    func saveDescription() {
        guard self.singleGroupVM.group.description != descriptionString && descriptionString != "" else {
            return
        }
        
        self.singleGroupVM.group.description = descriptionString
        self.singleGroupVM.updateGroupDescription(group: self.singleGroupVM.group, description: descriptionString)
        self.descriptionOpen.toggle()
    }
}

struct SingleGroupView_Previews: PreviewProvider {
    static var previews: some View {
        SingleGroupView(singleGroupVM: SingleGroupViewModel(groupRepository: MyGroupsRepository(), groupUserRepository: GroupMemberUserRepository(), group: AccountabilityGroup(id: "newgroup", title: "Test Group", description: "String", creationDate: Date(), activeMembers: ["member1"], pendingMembers: nil)))
    }
}
