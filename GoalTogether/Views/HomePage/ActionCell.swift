//
//  ActionCell.swift
//  GoalTogether
//
//  Created by Charlie Page on 4/3/21.
//

import SwiftUI

struct ActionCell: View {
    @ObservedObject var actionCellVM: ActionCellViewModel
    
    var onCommit: (Action) -> (Void) = { _ in }
    @State var settingsExpanded: Bool = false
    @State var additionalSettings: Bool = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(maxWidth: .infinity, maxHeight: 30)
                .foregroundColor(.gray)
            HStack {
                Image(systemName: actionCellVM.action.completed ? "checkmark.square.fill" : "square")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding()
                    .onTapGesture {
                        self.actionCellVM.action.completed.toggle()
                }
                TextField("Enter the Task Title", text: $actionCellVM.action.title, onCommit: {self.onCommit(self.actionCellVM.action)})
                Spacer()
                Image(systemName: "gearshape")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding()
                    .onTapGesture {
                        self.additionalSettings.toggle()
                    }
            }
        }.padding(.init(top: 0, leading: 10, bottom: 0, trailing: 10))
        .sheet(isPresented: $additionalSettings) {
            ActionEditPage(actionCellVM: actionCellVM, sheetActive: $additionalSettings)
        }
    }
}


struct ActionCell_Previews: PreviewProvider {
    static var previews: some View {
        ActionCell(actionCellVM: ActionCellViewModel(action: Action(title: "Test Task")))
    }
}
