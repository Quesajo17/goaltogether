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
    @State var showProfilePage = false
    /*
    @State var presentActionDetails = false
    @State var editingAction: ActionCellViewModel? = nil
 */
 
    private func signoutTapped() {
        actionListVM.actionRepository.endListening()
        authState.signout()
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    if actionListVM.previousActionCellViewModels.count > 0 {
                        HStack {
                            Text("Previous")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .padding(.leading)
                            Spacer()
                        }
                        ForEach(actionListVM.previousActionCellViewModels) { actionCellVM in
                            ActionCell(actionCellVM: actionCellVM)
                        }
                    }
                    if actionListVM.baseDateActionCellViewModels.count > 0 || presentAddNewItem {
                        HStack {
                            Text("Today")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .padding(.leading)
                            Spacer()
                        }
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
                    if actionListVM.baseDateWeekActionCellViewModels.count > 0 {
                        HStack {
                            Text(actionListVM.baseDateIsEndOfWeek == true ? "Next Week" : "This Week")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .padding(.leading)
                            Spacer()
                        }
                        ForEach(actionListVM.baseDateWeekActionCellViewModels) { actionCellVM in
                            ActionCell(actionCellVM: actionCellVM)
                        }
                    }
                    
                    if actionListVM.futureActionCellViewModels.count > 0 {
                        HStack {
                            Text("Future")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .padding(.leading)
                            Spacer()
                        }
                        ForEach(actionListVM.futureActionCellViewModels) { actionCellVM in
                            ActionCell(actionCellVM: actionCellVM)
                        }
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
            .sheet(isPresented: $showProfilePage) {
                ProfilePage()
            }
            .navigationBarItems(trailing: Button(action: { self.showProfilePage.toggle() } ) {
                Image(systemName: "person.circle")
                    .font(.system(size: 24))
            }
            )
            .navigationBarTitle("Test Title")
        }
    }
}
