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

import UIKit
import KakaoSDKCommon
import KakaoSDKAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        KakaoSDKCommon.initSDK(appKey: "b87ecfa105e5b418df6dee5fb15013e7")
        
        
        let navigationController = self.window?.rootViewController as! UINavigationController
        let viewController = navigationController.viewControllers.first as! ViewController
        viewController.reactor = ViewControllerReactor(service: Service())
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.handleOpenUrl(url: url)
        }
        return false
    }
}

//tet2
//내 맥
//내 맥 테스트2
//내 맥 테스트3
//내맥 테스트4
//내맥 searchTest 브랜치
