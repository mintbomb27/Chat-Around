//
//  GoogleAuth.swift
//  Chat Around
//
//  Created by Alok N on 20/05/21.
//

import UIKit
import GoogleSignIn
import Firebase

extension AppDelegate: GIDSignInDelegate{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error{
            print(error)
            return
        }
        guard let authentication = user.authentication else {return}
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential){ (authResult,error) in
            if let error = error{
                print("Google Auth Failed: \(error.localizedDescription)")
                return
            }
            
        }
        
        print("User Email: \(user.profile.email ?? "No Email") ")
    }
}
