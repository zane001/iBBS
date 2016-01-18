//
//  AppDelegate.swift
//
//  Created by Dongri Jin on 6/21/14.
//  Copyright (c) 2014 Dongri Jin. All rights reserved.
//

import OAuthSwift
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder {
    var window: UIWindow?
}

// MARK: handle callback url
extension AppDelegate {
    
    func applicationHandleOpenURL(url: NSURL) {
//       if (url.host == "oauth-callback") {
//            
//            if (url.path!.hasPrefix("/byr" )) {
//                OAuth2Swift.handleOpenURL(url)
//            }
//        }
        

//            OAuth2Swift.handleOpenURL(url)

    }
}

// MARK: ApplicationDelegate

extension AppDelegate: UIApplicationDelegate {
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        // Override point for customization after application launch.
//        let viewController: AuthViewController = AuthViewController()
//        let naviController: UINavigationController = UINavigationController(rootViewController: viewController)
//        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
//        self.window!.rootViewController = naviController
//        self.window!.makeKeyAndVisible()
        
        let infoDic = NSBundle.mainBundle().infoDictionary
        let currentAppVersion = infoDic!["CFBundleShortVersionString"] as! String
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let appVersion = userDefaults.stringForKey("appVersion")
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        if appVersion == nil || appVersion != currentAppVersion {
            userDefaults.setValue(currentAppVersion, forKey: "appVersion")
        } else {
            let home = storyBoard.instantiateViewControllerWithIdentifier("home") as! HomeTabBarController
                self.window!.rootViewController = home

        }
        
//        let guidanceVC = storyBoard.instantiateViewControllerWithIdentifier("guidanceVC") as! GuidanceViewController
//        self.window!.rootViewController = guidanceVC
        
        return true
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        applicationHandleOpenURL(url)
//        UIApplication.sharedApplication().keyWindow?.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
        return true
    }
}


