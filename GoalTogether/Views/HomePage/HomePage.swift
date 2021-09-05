//
//  HomePage.swift
//  GoalTogether
//
//  Created by Charlie Page on 4/3/21.
//

import SwiftUI

enum ActiveSheet: Identifiable {
    case profilePage, actionEditPage
    
    var id: Int {
        hashValue
    }
}

struct HomePage: View {
    
    @ObservedObject var actionListVM: ActionListViewModel
    @EnvironmentObject var authState: AuthenticationState
    
    @State var activeSheet: ActiveSheet?
    @State var presentAddNewItem = false

    @State var editingAction: Action? = nil

 
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
                            ActionCell(actionCellVM: actionCellVM, editingAction: self.$editingAction)
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
                            ActionCell(actionCellVM: actionCellVM, editingAction: self.$editingAction)
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
                            ActionCell(actionCellVM: actionCellVM, editingAction: self.$editingAction)
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
                            ActionCell(actionCellVM: actionCellVM, editingAction: self.$editingAction)
                        }
                    }
                }
                Button(action: {
                    self.editingAction = Action(title: "")
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("Add Action")
                    }
                }.padding()
            }
            .sheet(item: $activeSheet, onDismiss: didDismiss) { item in
                switch item {
                case .profilePage:
                    ProfilePage()
                case .actionEditPage:
                    ActionEditPage(actionEditVM: ActionEditViewModel(actionRepository: actionListVM.actionRepository ,action: editingAction!))
                }
            }
            .navigationBarItems(leading: Button(action: { self.activeSheet = .profilePage } ) {
                Image(systemName: "person.circle")
                    .font(.system(size: 24))
            }
            )
            .navigationBarTitle("Current Actions", displayMode: .inline)
        }
        .onChange(of: editingAction) { editingAction in
            if editingAction != nil {
                self.activeSheet = .actionEditPage
            }
        }
    }
    
    func didDismiss() {
        self.activeSheet = nil
        self.editingAction = nil
    }
}
