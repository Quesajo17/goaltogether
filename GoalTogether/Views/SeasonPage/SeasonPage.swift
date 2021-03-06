//
//  SeasonPage.swift
//  GoalTogether
//
//  Created by Charlie Page on 4/3/21.
//

import SwiftUI

enum ActiveSeasonSheet: Identifiable {
    case profilePage, aimEditPage, actionEditPage
    // actionEditPage
    
    var id: Int {
        hashValue
    }
}

struct SeasonPage: View {
    
    @ObservedObject var seasonAimsVM: SeasonAimsViewModel
    
    @State var activeSheet: ActiveSeasonSheet?
    @State var editingAim: Aim? = nil
    @State var editingAction: Action? = nil
    
    var body: some View {
        NavigationView {
            ScrollView {
                    if seasonAimsVM.inProgressAimCellViewModels.count > 0 {
                        HStack {
                            Text("In Progress")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .padding(.leading)
                            Spacer()
                        }
                        ForEach(seasonAimsVM.inProgressAimCellViewModels) { aimCellVM in
                            AimCell(aimCellVM: aimCellVM, editingAim: self.$editingAim, editingAction: self.$editingAction)
                                .padding()
                        }
                    }
                if seasonAimsVM.completedAimCellViewModels.count > 0 {
                    HStack {
                        Text("Completed")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.leading)
                        Spacer()
                    }
                    ForEach(seasonAimsVM.completedAimCellViewModels) { aimCellVM in
                        AimCell(aimCellVM: aimCellVM, editingAim: self.$editingAim, editingAction: self.$editingAction)
                            .padding()
                    }
                }
                Button(action: { self.editingAim = Aim(title: "", user: seasonAimsVM.currentUser.currentUser!, season: seasonAimsVM.featuredSeason!) }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("Add Aim")
                    }
                }.buttonStyle(RoundedRectangleBlackButtonStyle())
                .padding()
                }
            .sheet(item: $activeSheet, onDismiss: didDismiss) { item in
                switch item {
                case .profilePage:
                    ProfilePage()
                case .aimEditPage:
                    AimEditPage(aimEditVM: AimEditViewModel(aimRepository: seasonAimsVM.aimRepository, aim: self.editingAim!))
                case .actionEditPage:
                    // This is the one that needs to change to a different action repository.
                    ActionEditPage(actionEditVM: ActionEditViewModel(actionRepository: ActionRepository(), action: self.editingAction!))
                }
            }
            .navigationBarItems(leading: Button(action: { self.activeSheet = .profilePage } ) {
                Image(systemName: "person.circle")
                    .font(.system(size: 24))
            })
            .navigationBarTitle("\(seasonAimsVM.featuredSeason!.title!) Aims", displayMode: .inline)
        }
        .onChange(of: editingAim) { editingAim in
            if editingAim != nil {
                self.activeSheet = .aimEditPage
            }
            if editingAim == nil {
                print("Changed editingAim but it's nil")
            }
        }
        .onChange(of: editingAction) { editingAction in
            if editingAction != nil {
                self.activeSheet = .actionEditPage
            }
        }
    }
    func didDismiss() {
        self.activeSheet = nil
        self.editingAim = nil
    }
}


struct SeasonPage_Previews: PreviewProvider {
    static var previews: some View {
        SeasonPage(seasonAimsVM: SeasonAimsViewModel())
    }
}
