//
//  LogoTitleView.swift
//  GoalTogether
//
//  Created by Charlie Page on 4/5/21.
//

import SwiftUI

struct LogoTitleView: View {
    var body: some View {
        VStack {
            Circle()
                .fill(
                    AngularGradient(gradient: Gradient(colors: [.red, .yellow, .green, .blue, .purple, .red]), center: .center)
                )
                .frame(width: 100, height: 100)
            Text("GoalTogether")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("Reach goals with friends")
                .font(.headline)
        }
    }
}

struct LogoTitleView_Previews: PreviewProvider {
    static var previews: some View {
        LogoTitleView()
    }
}
