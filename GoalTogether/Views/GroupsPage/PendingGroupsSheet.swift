//
//  PendingGroupsSheet.swift
//  GoalTogether
//
//  Created by Charlie Page on 10/5/21.
//

import SwiftUI

struct PendingGroupsSheet: View {
    
    @ObservedObject var groupHubVM: GroupHubViewModel
    
    @State var sheetCount: Int
    
    @Environment(\.presentationMode) var presentationMode
    
    init(groupHubVM: GroupHubViewModel) {
        self.groupHubVM = groupHubVM
        
        self._sheetCount = State(initialValue: groupHubVM.pendingInviteViewModels.count)
    }
    
    var body: some View {
        if groupHubVM.pendingInviteViewModels.count >= 1 {
            TabView {
                ForEach(groupHubVM.pendingInviteViewModels) { singleGroupVM in
                    PendingGroupInviteView(singleGroupVM: singleGroupVM, onAcceptDecline: {
                        self.dismissIfEmpty()
                    })
                }
            }.tabViewStyle(PageTabViewStyle())
        }
    }
    
    func dismissIfEmpty() {
        sheetCount -= 1
        if sheetCount > 0 {
            return
        } else {
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct PendingGroupsSheet_Previews: PreviewProvider {
    static var previews: some View {
        PendingGroupsSheet(groupHubVM: GroupHubViewModel(groupRepository: MyGroupsRepository()))
    }
}
