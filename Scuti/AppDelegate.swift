//
//  AppDelegate.swift
//  Scuti
//
//  Created by mac on 12/09/2023.
//

import UIKit
import ScutiSDKSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        do {
//            try ScutiSDKManager.shared.initializeSDK(environment: .staging, appId: "6db28ef4-69b0-421a-9344-31318f898790")
            try ScutiSDKManager.shared.initializeSDK(environment: .development, appId: "1e6e003f-0b94-4671-bc35-ccc1b48ce87d")
        } catch {
            print("initializeSDK ex : \(error)")
        }
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        ScutiSDKManager.shared.endSession()
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        ScutiSDKManager.shared.endSession()
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        ScutiSDKManager.shared.startSession()
    }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

