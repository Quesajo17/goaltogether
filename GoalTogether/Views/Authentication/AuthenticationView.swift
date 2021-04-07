//
//  AuthenticationView.swift
//  GoalTogether
//
//  Created by Charlie Page on 4/5/21.
//

import SwiftUI

struct AuthenticationView: View {
    @EnvironmentObject var authState: AuthenticationState
    @State var authType = AuthenticationType.login
    
    
    
    var body: some View {
        ZStack {
            // SplashScreenView(namedString: authType.assetBackgroundName)
            VStack(spacing: 32) {
                LogoTitleView()
                AuthenticationFormView(authType: $authType)
                
                SignInWithAppleButton {
                    self.authState.login(with: .signInWithApple)
                }
                    .frame(width: 130, height: 44)
            }
        }
        .offset(y: UIScreen.main.bounds.width > 320 ? -75 : 0)
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}
