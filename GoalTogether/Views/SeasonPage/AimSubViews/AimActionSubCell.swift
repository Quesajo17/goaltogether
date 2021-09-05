//
//  AimActionSubCell.swift
//  GoalTogether
//
//  Created by Charlie Page on 7/2/21.
//

import SwiftUI

struct AimActionSubCell: View {
    var action: Action
    
    static let dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Image(systemName: action.completed == true ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(action.completed == true ? .green : .black)
                    .frame(width: 0.1 * geometry.size.width)
                HStack {
                    Text(action.title)
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                }
                .frame(width: 0.7 * geometry.size.width)
                Text(action.completionDate != nil ? action.completionDate! : action.startDate, formatter: AimActionSubCell.dateFormat)
                    .frame(width: 0.2 * geometry.size.width)
            }
        }
    }
}

struct ActionSubCell_Previews: PreviewProvider {
    static var previews: some View {
        AimActionSubCell(action: Action(title: "Testing title"))
    }
}
