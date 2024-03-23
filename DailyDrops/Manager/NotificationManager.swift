//
//  NotificationManager.swift
//  DailyDrops
//
//  Created by 차소민 on 3/24/24.
//

import Foundation
import UserNotifications

final class NotificationManager {
    static let shared = NotificationManager()
    
    private init() { }
    
    func checkNotificationAuthorization(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            guard let self else { return }
            switch settings.authorizationStatus {
            case .authorized:
                print("알림 권한이 허용되어 있습니다.")
                completion(true)
            case .denied:
                print("알림 권한이 거부되어 있습니다.")
                completion(false)
            default:
                print("오류")
                completion(false)
            }
        }
    }

}
