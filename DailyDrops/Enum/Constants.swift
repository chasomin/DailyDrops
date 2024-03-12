//
//  Constants.swift
//  DailyDrops
//
//  Created by 차소민 on 3/12/24.
//

import Foundation

enum Constants {
    enum NavigationTitle {
        case Water(goal: Int)
        case MySupplement
        case SetNotification
        case SearchSupplement
        
        var title: String {
            switch self {
            case .Water(let goal):
                return "목표! \(goal)잔 마시기"
            case .MySupplement:
                return "내 영양제 관리"
            case .SetNotification:
                return "알림 설정"
            case .SearchSupplement:
                return "영양제 검색"
            }
        }
    }

    enum WeekButtonTitle: String, CaseIterable {
        case mon = "월"
        case tue = "화"
        case wed = "수"
        case thu = "목"
        case fri = "금"
        case sat = "토"
        case sun = "일"
    }
    
    enum AlarmRepeatCount: Int {
        case first
        case second
        case third
    }
}
