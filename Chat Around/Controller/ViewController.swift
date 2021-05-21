//
//  ViewController.swift
//  Chat Around
//
//  Created by Alok N on 15/05/21.
//

import UIKit
import Firebase
import GoogleSignIn
import AuthenticationServices

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: GOOGLE AUTHENTICATION
    @IBAction func googleSignIn(_ sender: Any) {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    
    //MARK: APPLE AUTHENTICATION
    @IBAction func appleSignIn(_ sender: Any) {
        let request = requestAppleID()
        let controller = ASAuthorizationController(authorizationRequests: [request])
        
        controller.presentationContextProvider = self
        controller.delegate = self
        controller.performRequests()
    }

}
