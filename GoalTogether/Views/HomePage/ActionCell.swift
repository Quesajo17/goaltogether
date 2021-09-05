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
    
    @Binding var editingAction: Action?
    
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
                        self.actionCellVM.completeAction()
                }
                TextField("Enter the Task Title", text: $actionCellVM.action.title, onCommit: {self.onCommit(self.actionCellVM.action)})
                Spacer()
                Image(systemName: "pencil")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding()
                    .onTapGesture {
                        self.editingAction = self.actionCellVM.action
                    }
            }
        }.padding(.init(top: 0, leading: 10, bottom: 0, trailing: 10))
    }
}


struct ActionCell_Previews: PreviewProvider {
    static var previews: some View {
        ActionCell(actionCellVM: ActionCellViewModel(actionRepository: ActionRepository(), action: Action(title: "Test Task")), editingAction: .constant(nil))
    }
}
