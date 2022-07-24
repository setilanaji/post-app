//
//  AppDelegate.swift
//  post app
//
//  Created by Yudha Setyaji on 2022/7/22.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var realm: Realm!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        realm = try! Realm()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = window else {
            return false
        }
        let router = RootRouter(window: window, realm: realm)
        router.showRootScreen()
        return true
    }
}

