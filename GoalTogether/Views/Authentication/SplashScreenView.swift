//
//  SplashScreenView.swift
//  GoalTogether
//
//  Created by Charlie Page on 4/5/21.
//

import SwiftUI

struct SplashScreenView: View {
    
    let namedString: String
    
    var body: some View {
        if namedString == "login" {
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    LinearGradient(gradient: Gradient(colors: [.black, .white]), startPoint: .top, endPoint: .bottom)

                )
        } else {
            Rectangle()
                .background(
                    LinearGradient(gradient: Gradient(colors: [.white, .red]), startPoint: .top, endPoint: .bottom)
                )
        }

    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView(namedString: "login")
    }
}
