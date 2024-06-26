//
//  AppDelegate.swift
//  DailyDrops
//
//  Created by 차소민 on 3/7/24.
//

import UIKit
import Firebase
import Toast
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        
        setGlobalToastStyle()
        setGlobalFont()

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
        
        // MARK: 앱 최초 실행 시 목표 기본 값 저장
        if !UserDefaults.standard.bool(forKey: "isFirstLaunch") {
            let repository = RealmRepository()
            repository.createItem(RealmGoal(waterCup: 10, steps: 10000), completion: nil)
            UserDefaults.standard.set(true, forKey: "isFirstLaunch")
        }
        
        // MARK: Migration
        var configuration = Realm.Configuration(schemaVersion: 1) { migration, oldSchemaVersion in
            // version 0
            // version 1: RealmSupplementLog에 supplementFK: UUID 컬럼 추가, RealmSupplement에 deleteDate: Date? 컬럼 추가
            if oldSchemaVersion < 1 {
                // 단순한 테이블 컬럼이 추가되는 경우에는 별도 코드 작성 안 해도 된다.
                print("Schema version: 0 -> 1")
            }
        }
        
        let defaultRealm = Realm.Configuration.defaultConfiguration.fileURL!
        let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Constants.AppGroupID)
        let realmURL = container?.appendingPathComponent("default.realm")

        if FileManager.default.fileExists(atPath: defaultRealm.path) {
            do {
                _ = try FileManager.default.replaceItemAt(realmURL!, withItemAt: defaultRealm)
                configuration = Realm.Configuration(fileURL: realmURL, schemaVersion: 2)
            } catch {
               print("Error info: \(error)")
            }
        } else {
            configuration = Realm.Configuration(fileURL: realmURL, schemaVersion: 2)
        }

        Realm.Configuration.defaultConfiguration = configuration

        // MARK: 기존 삭제된 영양제 로그 삭제, 로그 FK로 해당 영양제 ID 지정
        let repository = RealmRepository()
        repository.updateInvalidLog()
        
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
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge,.banner,.list,.sound])
    }
}
