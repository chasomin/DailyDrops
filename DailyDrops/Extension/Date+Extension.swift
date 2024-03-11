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
}