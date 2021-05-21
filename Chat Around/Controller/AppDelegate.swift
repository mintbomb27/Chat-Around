//
//  AppDelegate.swift
//  Chat Around
//
//  Created by Alok N on 15/05/21.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseMessaging


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = UIWindow()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        //MARK: FCM
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert,.badge,.sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions){_,_ in }
        Messaging.messaging().delegate = self
        application.registerForRemoteNotifications()
        
        //Fetching ClientID from GoogleServices-Info.plist
        var clientID: [String:Any]?
        if let gservicesPlistPath = Bundle.main.url(forResource: "GoogleService-Info", withExtension:"plist"){
            do{
                let gservicesPlist = try Data(contentsOf: gservicesPlistPath)
                if let dict = try PropertyListSerialization.propertyList(from: gservicesPlist, options: [], format: nil) as? [String: Any]{
                    clientID = dict
                }
            } catch {
                print(error)
            }
        }
        
        //MARK: Google Sign In
        GIDSignIn.sharedInstance()?.clientID = clientID?["CLIENT_ID"] as? String
        GIDSignIn.sharedInstance()?.delegate = self
        
        initFirstVC()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }

    private func initFirstVC(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let authStatus = UserDefaults.standard.bool(forKey: "isSignedIn")
        
        let navVC = storyboard.instantiateViewController(identifier: "navVC")
        self.window?.rootViewController = navVC
        if(authStatus == true) {
            //take to Chats
        }
        window?.makeKeyAndVisible()
    }

}
