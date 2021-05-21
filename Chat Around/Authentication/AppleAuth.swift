//
//  AppleAuth.swift
//  Chat Around
//
//  Created by Alok N on 20/05/21.
//

import UIKit
import AuthenticationServices
import Firebase
import CryptoKit

extension ViewController: ASAuthorizationControllerDelegate {
    
    //Request AppleID
    func requestAppleID()-> ASAuthorizationAppleIDRequest{
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName,.email]
        
        let nonce = randomNonceString()
        request.nonce = sha256(nonce)
        currentNonce = nonce
        return request
    }
    
    //SHA256 Function for Nonce
    func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
      }.joined()

      return hashString
    }
    
    func randomNonceString(length: Int = 32) -> String {
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
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredentials = authorization.credential as? ASAuthorizationAppleIDCredential else {
            fatalError("Invalid State: Login callback received, but no request sent")
        }
        guard let appleIDToken = appleIDCredentials.identityToken else {
            print("Unable to fetch the ID Token")
            return
        }
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            print("Unable to Parse the ID Token")
            return
        }
        let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: currentNonce)
        Auth.auth().signIn(with: credential, completion: { (authResult, error) in
            if let error = error{
                self.alertPrompt(message: error.localizedDescription, title: "Oops!", prompt: "OK")
                return
            }
        })
    }
}
extension ViewController: ASAuthorizationControllerPresentationContextProviding{ 
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
