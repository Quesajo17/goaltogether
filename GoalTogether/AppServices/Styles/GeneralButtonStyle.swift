//
//  GeneralButtonStyle.swift
//  GoalTogether
//
//  Created by Charlie Page on 4/5/21.
//

import SwiftUI

struct GeneralButtonStyle: ButtonStyle {
 
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(width: 130, height: 44)
            .foregroundColor(Color.white)
            .background(Color.black)
            .cornerRadius(8)
    }
}
