//
//  AuthenticationState.swift
//  GoalTogether
//
//  Created by Charlie Page on 4/4/21.
//

// Used this tutorial to create: https://www.alfianlosari.com/posts/building-authentication-in-swiftui-using-firebase-auth-sdk-and-sign-in-with-apple/

import Foundation
import Firebase
import AuthenticationServices
import CryptoKit

enum LoginOption {
    case signInWithApple
    case emailAndPassword(email: String, password: String)
    case signInWithGoogle
}

class AuthenticationState: NSObject, ObservableObject {
    
    // The firebase logged in user, and the userProfile associated with the users collection
    @Published var loggedInUser: User?
    
    
    @Published var isAuthenticating = false
    @Published var error: NSError?
    
    static let shared = AuthenticationState()
    
    private let auth = Auth.auth()
    fileprivate var currentNonce: String?
    
    override init() {
        super.init()
        auth.addStateDidChangeListener { [weak self] (_, user) in
            self?.loggedInUser = user
        }
    }
    
    
    func login(with loginOption: LoginOption) {
        self.isAuthenticating = true
        self.error = nil
        
        switch loginOption {
            case .signInWithApple:
                handleSignInWithApple()
                
            case .signInWithGoogle:
                handleSignInWithGoogle()
        
            case let .emailAndPassword(email, password):
                handleSignInWith(email: email, password: password)
        }
    }
    
    
    func signup(email: String, password: String, passwordConfirmation: String) {
        guard password == passwordConfirmation else {
            self.error = NSError(domain: "", code: 9210, userInfo: [NSLocalizedDescriptionKey: "Password and confirmation does not match"])
            return
        }
        
        self.isAuthenticating = true
        self.error = nil
        
        auth.createUser(withEmail: email, password: password, completion: handleAuthResultCompletion)
        
    }
    
    
    func signout() {
        try? auth.signOut()
        self.loggedInUser = nil
    }

    
    private func handleSignInWith(email: String, password: String) {
        auth.signIn(withEmail: email, password: password, completion: handleAuthResultCompletion)
    }
    
    
    private func handleAuthResultCompletion(auth: AuthDataResult?, error: Error?) {
        DispatchQueue.main.async {
            self.isAuthenticating = false
            if let user = auth?.user {
                // self.loggedInUser = user
            } else if let error = error {
                self.error = error as NSError
            }
        }
    }
    
    
    private func handleSignInWithGoogle() {
        // TODO
    }
}

extension AuthenticationState: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows.first!
    }

    @available(iOS 13, *)
    private func handleSignInWithApple() {
      let nonce = randomNonceString()
      currentNonce = nonce
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]
      request.nonce = sha256(nonce)

      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
      authorizationController.delegate = self
      authorizationController.presentationContextProvider = self
      authorizationController.performRequests()
    }

    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
      }.joined()

      return hashString
    }
    
}

@available(iOS 13.0, *)
extension AuthenticationState {

  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
      guard let nonce = currentNonce else {
        fatalError("Invalid state: A login callback was received, but no login request was sent.")
      }
      guard let appleIDToken = appleIDCredential.identityToken else {
        print("Unable to fetch identity token")
        return
      }
      guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
        print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
        return
      }
      // Initialize a Firebase credential.
      let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                idToken: idTokenString,
                                                rawNonce: nonce)
        
        // Sign in with Firebase.
        Auth.auth().signIn(with: credential, completion: handleAuthResultCompletion)
    }
  }

  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
    print("Sign in with Apple errored: \(error)")
    self.isAuthenticating = false
    self.error = error as NSError
  }

}

// Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
private func randomNonceString(length: Int = 32) -> String {
  precondition(length > 0)
  let charset: Array<Character> =
      Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
  var result = ""
  var remainingLength = length

  while remainingLength > 0 {
    let randoms: [UInt8] = (0 ..< 16).map { _ in
      var random: UInt8 = 0
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
      if errorCode != errSecSuccess {
        fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
      }
      return random
    }

    randoms.forEach { random in
      if remainingLength == 0 {
        return
      }

      if random < charset.count {
        result.append(charset[Int(random)])
        remainingLength -= 1
      }
    }
  }

  return result
}


