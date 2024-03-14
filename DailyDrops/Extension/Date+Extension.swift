//
//  Date+Extension.swift
//  DailyDrops
//
//  Created by 차소민 on 3/11/24.
//

import Foundation

extension Date {
    func dateFormat() -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy년 MM월 dd일"
        return format.string(from: self)
    }
    
    func dateFilterDay() -> Int {
        let format = DateFormatter()
        format.dateFormat = "e" // 일~토 =>  1~7
        guard let result = Int(format.string(from: self)) else { return 0}
        return result
    }
    
    func dateFilterTime() -> String {
        let format = DateFormatter()
        format.dateFormat = "HH:mm"
        return format.string(from: self)
    }
}
