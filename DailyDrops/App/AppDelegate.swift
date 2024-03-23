//
//  AppDelegate.swift
//  DailyDrops
//
//  Created by 차소민 on 3/7/24.
//

import UIKit
import Firebase
import Toast

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        
        setGlobalToastStyle()
        setGlobalFont()

        // TODO: 권한 요청 앱 진입 시 물어볼지, 걸음수 탭에 들어가면 물어볼지 정하기
        HealthManager.shared.requestAuthoriaztion()
        
        UNUserNotificationCenter.current().delegate = self
        // 알림 권한 설정
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success, error in
            guard error == nil else {
                print("=== 알림 권한 설정 오류!!: ", error)
                return
            }
            
            if success {
                print("알림 권한 허용")
            } else {
                print("알림 권한 거부")
                //TODO: Alert
            }
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
    
    private func setGlobalToastStyle() {
        var style = ToastStyle()
        style.messageColor = .pointColor
        style.backgroundColor = .titleColor
        style.messageFont = .boldBody
        style.verticalPadding = 15
        style.horizontalPadding = 20
        style.cornerRadius = 15
        ToastManager.shared.style = style
    }

    private func setGlobalFont() {
        let navigationTitlefont = UIFont.boldTitle
        let largeFont = UIFont.largeBoldTitle
        let tabBarFont = UIFont.caption
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: navigationTitlefont]
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.font: largeFont]
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: tabBarFont], for: .normal)
        
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.callout], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldCallout], for: .selected)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // foreground 에서 알림을 받고자 할 경우
    // ex) 친구랑 1:1 채팅할 경우, 다른 단톡방이나 다른 갠톡방 푸시만 오는 것 처럼, 특정 화면/특정 조건에 대해서 포그라운드 알림을 받게 설정하는 것도 가능!
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.badge,.banner,.list,.sound])
    }

    
    
}
