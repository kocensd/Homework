//
//  AppDelegate.swift
//  Homework
//
//  Created by SangDo on 2020/09/06.
//  Copyright © 2020 SangDo. All rights reserved.
//
//test1
//test2
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let navigationController = self.window?.rootViewController as! UINavigationController
        let viewController = navigationController.viewControllers.first as! ViewController
        viewController.reactor = ViewControllerReactor(service: Service())
        
        return true
    }
}

//tet2
