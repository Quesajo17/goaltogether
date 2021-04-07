//
//  AuthenticationFormView.swift
//  GoalTogether
//
//  Created by Charlie Page on 4/5/21.
//

import SwiftUI

struct AuthenticationFormView: View {

    @EnvironmentObject var authState: AuthenticationState

    @State var email: String = ""
    @State var password: String = ""
    @State var passwordConf: String = ""
    @State var isShowingPassword = false

    @Binding var authType: AuthenticationType

    var body: some View {
        VStack(spacing: 16) {
            TextField("Email", text: $email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)

            if isShowingPassword {
                TextField("Password", text: $password)
                .textContentType(.password)
                .autocapitalization(.none)
            } else {
                SecureField("Password", text: $password)
            }

            if authType == .signup {
                if isShowingPassword {
                    TextField("Password Confirmation", text: $passwordConf)
                        .textContentType(.password)
                        .autocapitalization(.none)
                } else {
                    SecureField("Password Confirmation", text: $passwordConf)
                }
            }

            Toggle("Show password", isOn: $isShowingPassword)
                .foregroundColor(.red)

            Button(action: emailAuthenticationTapped) {
                Text(authType.text)
                .font(.callout)
            }
            .buttonStyle(GeneralButtonStyle())
            .disabled(email.count == 0 && password.count == 0)

            Button(action: footerButtonTapped) {
                Text(authType.footerText)
                .font(.callout)
            }
            // .foregroundColor(.white)
        }
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .frame(width: 288)
        .alert(item: $authState.error) { error in
            Alert(title: Text("Error"), message: Text(error.localizedDescription))
        }
    }

    private func emailAuthenticationTapped() {
        switch authType {
        case .login:
            print("Login attempted")
            authState.login(with: .emailAndPassword(email: email, password: password))

        case .signup:
            authState.signup(email: email, password: password, passwordConfirmation: passwordConf)
        }
    }

    private func footerButtonTapped() {
        clearFormField()
        authType = authType == .signup ? .login : .signup
    }

    private func clearFormField() {
        email = ""
        password = ""
        passwordConf = ""
        isShowingPassword = false
    }
}

struct AuthenticationFormView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationFormView(authType: .constant(.login))
    }
}
