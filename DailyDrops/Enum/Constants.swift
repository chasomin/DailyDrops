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
                return "목표!\n\(goal)걸음 걷기"
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
        case notification = "알림 설정"
    }
}
