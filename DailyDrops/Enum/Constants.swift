//
//  Constants.swift
//  DailyDrops
//
//  Created by 차소민 on 3/12/24.
//

import Foundation

enum Constants {
    enum NavigationTitle {
        case Water(goal: Int, cup: Int)
        case MySupplement
        case SetNotification
        case SearchSupplement
        case Step(goal: Int)
        
        var title: String {
            switch self {
            case .Water(let goal, let cup):
                if goal == cup {
                    return "목표 달성!"
                } else {
                    return "목표!\n\(goal)잔 마시기"
                }
            case .MySupplement:
                return "오늘의 영양제"
            case .SetNotification:
                return "알림 설정"
            case .SearchSupplement:
                return "영양제 검색"
            case .Step(let goal):
                return "목표!\n\(goal.numberToDecimal())걸음 걷기"
            }
        }
    }

    enum WeekButtonTitle: String, CaseIterable {
        case sun = "일"
        case mon = "월"
        case tue = "화"
        case wed = "수"
        case thu = "목"
        case fri = "금"
        case sat = "토"
    }
    
    enum AlarmRepeatCount: Int {
        case first
        case second
        case third
    }
    
    enum Topic: Int, CaseIterable {
        case water
        case supplement
        case step
        
        var title: String {
            switch self {
            case .water:
                "물 마시기"
            case .supplement:
                "영양제"
            case .step:
                "걸음 수"
            }
        }
    }
    
    enum Setting: String, CaseIterable {
        case waterGoal = "물 마시기 목표 설정"
        case stepGoal = "걸음 수 목표 설정"
        case supplement = "영양제 관리"
        case notification = "알림 / 건강데이터 권한 설정"
    }
    
    enum Permission: CaseIterable {
        case notification
        case health
        
        var title: String {
            switch self {
            case .notification:
                "알림 설정"
            case .health:
                "건강 데이터 설정"
            }
        }
        
        var description: String {
            switch self {
            case .notification:
                "영양제 알림을 위해 알림 허용이 필요해요\n⚠️ 알림을 끄면 이전에 설정해둔 알림이 사라져요"
            case .health:
                "걸음 수 측정을 위해 건강 데이터 허용이 필요해요\n아이폰 설정 > 건강 > 데이터 접근 및 기기 > DailyDrops > 걸음"
            }
        }
    }
    
    enum Empty: String {
        case supplement = "저장된 영양제가 없어요\n+ 버튼을 눌러 영양제를 추가해 보세요"
        case search = "검색 결과가 없어요\n키워드로 검색하면 더 정확한 결과가 나와요"
        case todaySupplement = "오늘 복용할 영양제가 없어요"
    }
    
    static let AppGroupID = "group.com.dailydrops"
    static let widgetID = "WaterWidget"
}
