//
//  AppDelegate.swift
//  MyApp
//
//  Created by Fernando Farias on 22/10/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    /* func completionHandler: ([Track]?, Error?) -> Void {
        print("hola")
    } */

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        /* let api = APIManager()
        api.getMusic(completion: { (_, error) in
            if error == nil {
                print("tracklist fetch complete")
            } else {
                print(error!)
            }
        }) */

        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
         /* Called when the user discards a scene session.
         If any sessions were discarded while the application was not running, this will be called shortly
         after application:didFinishLaunchingWithOptions.
          Use this method to release any resources that were specific to the discarded scenes,
          as they will not return. */
    }
}
