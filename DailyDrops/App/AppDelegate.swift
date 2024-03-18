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
        style.verticalPadding = 10
        style.horizontalPadding = 15
        style.cornerRadius = 15
        ToastManager.shared.style = style
        ToastManager.shared.position = .top
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

