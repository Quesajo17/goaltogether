//
//  AimCell.swift
//  GoalTogether
//
//  Created by Charlie Page on 6/25/21.
//

import SwiftUI

struct AimCell: View {
    
    @ObservedObject var aimCellVM: MyAimCellViewModel
    @State var expandedView: Bool = false
    
    @Binding var editingAim: Aim?
    @Binding var editingAction: Action?
    
    var body: some View {
        // GeometryReader { geometry in
            VStack {
                HStack {
                    VStack {
                        HStack {
                            Text(aimCellVM.aim.title)
                                .fontWeight(.bold)
                                .padding(.leading, 5)
                                .padding(.bottom, 1)
                                .fixedSize(horizontal: false, vertical: true)
                            Spacer()
                        }
                        if aimCellVM.aim.description != nil {
                            Text(aimCellVM.aim.description!)
                                .padding(.leading, 5)
                                .padding(.trailing, 5)
                                .padding(.bottom, 5)
                                .fixedSize(horizontal: false, vertical: true)
                            
                        }
                    }// .frame(width: 0.9 * geometry.size.width)
                    VStack {
                        Image(systemName: "pencil")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding()
                            .onTapGesture {
                                self.editingAim = self.aimCellVM.aim
                            }
                        Image(systemName: expandedView == false ? "chevron.down.circle" : "chevron.up.circle")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding()
                            .onTapGesture {
                                self.expandedView.toggle()
                                if expandedView == true {
                                    self.aimCellVM.loadAimDetails()
                                }
                            }
                    }.padding(.top)
                    .padding(.bottom)
                    // .frame(width: 0.1 * geometry.size.width)
                }
                if expandedView == true && aimCellVM.actions != nil {
                    Text("Actions")
                        .font(.subheadline)
                    ForEach(aimCellVM.actions!) { action in
                        AimActionSubCell(action: action)
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
            }.background(RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(Color.gray))
        // }
    }
}

struct AimCell_Previews: PreviewProvider {
    static var previews: some View {
        AimCell(aimCellVM: MyAimCellViewModel(aimRepository: MyAimsRepository(), aim: Aim(id: nil, title: "Original Goal", userId: nil, seasonId: "newSeasonId", startDate: Date(), plannedEndDate: Date(), completed: false, completionDate: nil, description: "This is my first long term goal. We'll see if I'm able to accomplish it effectively.", actions: nil)), editingAim: .constant(nil), editingAction: .constant(nil))
    }
}
