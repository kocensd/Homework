//
//  AppDelegate.swift
//  Homework
//
//  Created by SangDo on 2020/09/06.
//  Copyright © 2020 SangDo. All rights reserved.
//
//test1 브랜치
//test2
//test3
//회사맥 mainTest 브랜치
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

