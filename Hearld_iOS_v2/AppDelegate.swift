//
//  AppDelegate.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 22/10/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import YYCache

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let cache = YYMemoryCache.init()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let realm = try! Realm()
        // 若userDefault中uuid不为空，且本地数据库中存在该用户，则直接登录到首页
        if HearldUserDefault.uuid != nil && realm.objects(User.self).filter("uuid == '\(HearldUserDefault.uuid!)'").isEmpty == false{
            HearldUserDefault.isLogin = true
            let navigationVC = MainNavigationController()
            let mainVC = MainTabBarController()
            navigationVC.pushViewController(mainVC, animated: false)
            self.window?.rootViewController = navigationVC
        // 否则转场到登录界面
        }else{
            let LoginVC = LoginViewController()
            self.window?.rootViewController = LoginVC
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        cache.removeAllObjects()
    }


}

