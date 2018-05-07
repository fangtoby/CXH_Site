    //
//  AppDelegate.swift
//  CXH_Site
//
//  Created by hao peng on 2017/4/12.
//  Copyright © 2017年 zltx. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SVProgressHUD
import Siren
import XCGLogger
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navLogin:UINavigationController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setApp()
        //启动极光推送
        PHJPushHelper.setupWithOptions(launchOptions: launchOptions,delegate:self)
        let userId=userDefaults.object(forKey: "userId") as? Int
        if userId != nil{
            let vc=UINavigationController(rootViewController:IndexViewController())
            self.window?.rootViewController=vc
        }else{
            //初始化登录页面
            navLogin=UINavigationController(rootViewController:LoginViewController())
            self.window?.rootViewController=navLogin
        }

        return true
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //在appdelegate注册设备处调用
        JPUSHService.registerDeviceToken(deviceToken)
        
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        //// Required,For systems with less than or equal to iOS6
        JPUSHService.handleRemoteNotification(userInfo)
    }

    //接收通知消息
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        // Required, iOS 7 Support
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(.newData)
        if(application.applicationState == UIApplicationState.active){//如果程序活动在前台
            
        }else{//如果程序运行在后台
            
        }
        /**
        发送通知 在UITabBarController更新个人中心的角标
        */
        NotificationCenter.default.post(name: Notification.Name(rawValue: "postPersonalCenter"), object:1, userInfo:nil)
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        /**
        版本检查每次启动应用程序执行Immediately
        版本检查每天执行一次 Daily
        版本检查每周执行一次Weekly
        */
        Siren.shared.checkVersion(checkType: .immediately)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        JPUSHService.resetBadge();
        application.applicationIconBadgeNumber=0;
        /**
        版本检查每次启动应用程序执行Immediately
        版本检查每天执行一次 Daily
        版本检查每周执行一次Weekly
        */
        Siren.shared.checkVersion(checkType: .daily)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }



}
// MARK: - 实现极光推送协议
extension AppDelegate:JPUSHRegisterDelegate{
        ///用户点击通知栏进入app执行
        @available(iOS 10.0, *)
        func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {

            completionHandler()
        }
        ///用户在前台接收到推送消息执行
        @available(iOS 10.0, *)
        func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler:((Int) -> Void)!) {
            completionHandler(Int(UNNotificationPresentationOptions.alert.rawValue))
        }

}

extension AppDelegate{
    func setApp(){
        //开启键盘框架
        IQKeyboardManager.sharedManager().enable = true
        //设置菊花图默认前景色和背景色
        SVProgressHUD.setForegroundColor(UIColor(white: 1, alpha: 1))
        SVProgressHUD.setBackgroundColor(UIColor(white: 0.15, alpha: 0.85))
        setUpNav()
        setupSiren()
        JPUSHService.setLogOFF()
    }
    /**
     设置导航栏的各种状态
     */
    func setUpNav(){
        //导航栏背景色
        UINavigationBar.appearance().barTintColor=UIColor.applicationMainColor();
        //导航栏文字颜色
        UINavigationBar.appearance().titleTextAttributes=NSDictionary(object:UIColor.white, forKey:NSAttributedStringKey.foregroundColor as NSCopying) as? [NSAttributedStringKey : Any];
        UINavigationBar.appearance().tintColor=UIColor.white
//        //将返回按钮的文字position设置不在屏幕上显示
//        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(CGFloat(NSInteger.min),CGFloat(NSInteger.min)), for:UIBarMetrics.default)
        //去掉导航栏黑线
        UINavigationBar.appearance().shadowImage=UIImage.imageFromColor(UIColor.applicationMainColor())
        //改变状态栏的颜色
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent;
    }
    /**
     版本更新
     */
    func setupSiren() {
        let siren = Siren.shared



        // Optional
        siren.debugEnabled = false

        siren.appName="城乡惠Tool"

        // Optional - Defaults to .Option
        //        siren.alertType = .Option // or .Force, .Skip, .None

        // Optional - Can set differentiated Alerts for Major, Minor, Patch, and Revision Updates (Must be called AFTER siren.alertType, if you are using siren.alertType)
        siren.majorUpdateAlertType = .option
        siren.minorUpdateAlertType = .option
        siren.patchUpdateAlertType = .option
        siren.revisionUpdateAlertType = .option

        // Optional - Sets all messages to appear in Spanish. Siren supports many other languages, not just English and Spanish.
        //        siren.forceLanguageLocalization = .Spanish

        // Required
        siren.checkVersion(checkType: .immediately)
    }
}


