//
//  MemberActionCell.swift
//  GoalTogether
//
//  Created by Charlie Page on 9/22/21.
//

import SwiftUI

struct MemberActionCell: View {
    @ObservedObject var actionCellVM: ActiveMemberActionCellViewModel
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: actionCellVM.action.completed ? "checkmark.square.fill" : "square")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.lightText)
                    .padding()
                Text(actionCellVM.action.title)
                    .foregroundColor(.lightText)
                Spacer()
            }
            HStack {
                Spacer()
                Text(actionCellVM.action.completed ? "Completed: " : "Due: ")
                    .foregroundColor(.lightText)
                Text("\(actionCellVM.action.referenceDate, style: .date)")
                    .foregroundColor(.lightText)
            }.padding()
        }.background(RoundedRectangle(cornerRadius: 8))
        .foregroundColor(actionCellVM.action.completed ? Color.green : Color.gray)
        .padding(.init(top: 0, leading: 10, bottom: 0, trailing: 10))
    }
}

struct MemberActionCell_Previews: PreviewProvider {
    static var previews: some View {
        MemberActionCell(actionCellVM: ActiveMemberActionCellViewModel(action: Action(title: "Test Task")))
    }
}
