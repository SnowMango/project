//
//  AppDelegate.swift
//  ZQSubject
//
//  Created by 郑丰 on 2025/4/11.
//

import UIKit
import IQKeyboardManagerSwift
import IQKeyboardToolbarManager


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
   

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        env = EnvManager.shared.loadEnvironment()
        launchSetup()
        let idfv = UIDevice.current.identifierForVendor?.uuidString ?? "--"
        
        Logger.info("IDFV \(idfv)")
    
        let production: Bool = switch env {
        case .dev,.local: false
        case .test: true
        case .pro: true
        }
        
        JPUSHService.setup(withOption: launchOptions, appKey: JPushAK, channel: channel, apsForProduction: production, advertisingIdentifier: nil)
        
        JPUSHService.registrationIDCompletionHandler { resCode, registrationID in
            if let registrationID = registrationID, resCode == 0 {
                Logger.info("RegistrationID 获取成功:\(registrationID)")
                AppManager.shared.registrationID = registrationID
                AppManager.shared.reportPush()
                
            }else {
                Logger.info("RegistrationID 获取失败:\(resCode))")
            }
        }
       
        UNUserNotificationCenter.current().requestAuthorization(options: .badge) { granted, error in
            if granted {
                if #available(iOS 16.0, *) {
                    UNUserNotificationCenter.current().setBadgeCount(0) { _ in
                        
                    }
                } else {
                    UIApplication.shared.applicationIconBadgeNumber = 0
                }
            }
        }
        
        return true
    }
    
    // MARK: App setup
    func launchSetup(){
        
        //配置日志
        Logger.setup()
        AppManager.shared.reloadAppResource()
        //Routers
        Router.shared.appRoutes()
        Router.shared.webRoutes()
        
        // Keyboard Congfig
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardToolbarManager.shared.isEnabled = true
        // JPUSH
        let entity = JPUSHRegisterEntity()
        entity.types = NSInteger(UNAuthorizationOptions.alert.rawValue) |
        NSInteger(UNAuthorizationOptions.sound.rawValue) |
        NSInteger(UNAuthorizationOptions.badge.rawValue)
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        

    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if let scheme = url.scheme, scheme == AppScheme {
            return Router.route(url: url)
        }
        return true
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
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([any UIUserActivityRestoring]?) -> Void) -> Bool {
        return true
    }

    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Logger.debug("get the deviceToken success")
        // 注册devicetoken
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        Logger.error("didfail to register for remote notification with \(error)")
    }
    
    // iOS10以上静默推送会走该回调
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // 注意调用
        JPUSHService.handleRemoteNotification(userInfo)
        Logger.info("收到通知:\(userInfo)")
        completionHandler(.newData)
    }

}
extension AppDelegate: JPUSHRegisterDelegate, JPUSHInAppMessageDelegate {
    
    //MARK - JPUSHRegisterDelegate
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: (() -> Void)) {
        
        let userInfo = response.notification.request.content.userInfo
        let request = response.notification.request // 收到推送的请求
//        let content = request.content // 收到推送的消息内容
        
//        let badge = content.badge // 推送消息的角标
//        let body = content.body   // 推送消息体
//        let sound = content.sound // 推送消息的声音
//        let subtitle = content.subtitle // 推送消息的副标题
//        let title = content.title // 推送消息的标题
        if let _ = request.trigger as? UNPushNotificationTrigger {
            // 注意调用
            JPUSHService.handleRemoteNotification(userInfo)
            Logger.info("iOS10 收到<远程>通知:\(userInfo)")
        }else {
            Logger.info("iOS10 收到本地通知:\(userInfo)")
        }
        completionHandler()
        
    }
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification,
                                 withCompletionHandler completionHandler: ((Int) -> Void)) {
        let userInfo = notification.request.content.userInfo
        let request = notification.request // 收到推送的请求
//        let content = request.content // 收到推送的消息内容
        
//        let badge = content.badge // 推送消息的角标
//        let body = content.body   // 推送消息体
//        let sound = content.sound // 推送消息的声音
//        let subtitle = content.subtitle // 推送消息的副标题
//        let title = content.title // 推送消息的标题
        if let _ = request.trigger as? UNPushNotificationTrigger  {
            // 注意调用
            JPUSHService.handleRemoteNotification(userInfo)
            Logger.info("iOS10 收到<远程>通知:\(userInfo)")
        } else {
            Logger.info("iOS10 收到本地通知:\(userInfo)")
        }
        
        completionHandler(Int(UNNotificationPresentationOptions.badge.union([.sound,.list, .banner]).rawValue))
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification) {
        
    }
    
    func jpushNotificationAuthorization(_ status: JPAuthorizationStatus, withInfo info: [AnyHashable : Any]?) {
        Logger.info("receive notification authorization status:\(status), info:\(String(describing: info))")
    }
    
    //MARK - JPushInAppMessageDelegate
    func jPush(inAppMessageDidShow inAppMessage: JPushInAppMessage) {
        let messageId = inAppMessage.mesageId;
        let title = inAppMessage.title;
        let content = inAppMessage.content;
        // ... 更多参数获取请查看JPushInAppMessage
        Logger.info("\(#function) - messageId:\(messageId), title:\(title), content:\(content)")
    }
    
    func jPush(inAppMessageDidClick inAppMessage: JPushInAppMessage) {
        let messageId = inAppMessage.mesageId;
        let title = inAppMessage.title;
        let content = inAppMessage.content;
        // ... 更多参数获取请查看JPushInAppMessage
        Logger.info("\(#function) - messageId:\(messageId), title:\(title), content:\(content)")
    }
}
