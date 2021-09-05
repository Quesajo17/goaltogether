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
            Image("Icon")
                .resizable()
                .frame(width: 150, height: 150)
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
