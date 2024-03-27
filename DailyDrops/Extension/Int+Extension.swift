//
//  Int+Extension.swift
//  DailyDrops
//
//  Created by 차소민 on 3/27/24.
//

import Foundation

extension Int {
    func numberToDecimal() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let result = numberFormatter.string(from: NSNumber(value: self)) ?? ""
        return result
    }
}
