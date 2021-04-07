//
//  HomePage.swift
//  GoalTogether
//
//  Created by Charlie Page on 4/3/21.
//

import SwiftUI

struct HomePage: View {
    
    @ObservedObject var actionListVM = ActionListViewModel()
    @EnvironmentObject var authState: AuthenticationState
    
    @State var presentAddNewItem = false
    @State var showSignInForm = false
    
    private func signoutTapped() {
        authState.signout()
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                Text("Previous")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                LazyVStack {
                    ForEach(actionListVM.previousActionCellViewModels) { actionCellVM in
                        ActionCell(actionCellVM: actionCellVM)
                    }
                }
                Text("Today")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                LazyVStack {
                    ForEach(actionListVM.baseDateActionCellViewModels) { actionCellVM in
                        ActionCell(actionCellVM: actionCellVM)
                    }
                    if presentAddNewItem {
                        ActionCell(actionCellVM: ActionCellViewModel(action: (Action(title: "")))) { action in
                            self.actionListVM.addAction(action)
                            self.presentAddNewItem.toggle()
                        }
                    }
                }
                Text(actionListVM.baseDateIsEndOfWeek == true ? "Next Week" : "This Week")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                LazyVStack {
                    ForEach(actionListVM.baseDateWeekActionCellViewModels) { actionCellVM in
                        ActionCell(actionCellVM: actionCellVM)
                    }
                }
                Text("Future")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                LazyVStack {
                    ForEach(actionListVM.futureActionCellViewModels) { actionCellVM in
                        ActionCell(actionCellVM: actionCellVM)
                    }
                }
                Button(action: {self.presentAddNewItem.toggle()}) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("Add Action")
                    }
                }.padding()
            }
            .navigationBarItems(trailing: Button(action: { signoutTapped() } ) {
                Text("Logout")
            }
            )
            .navigationBarTitle("Test Title")
        }
    }
}
