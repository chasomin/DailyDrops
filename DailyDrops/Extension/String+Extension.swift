//
//  String+Extension.swift
//  DailyDrops
//
//  Created by 차소민 on 3/28/24.
//

import Foundation

extension String {
    func formatDate() -> Date {
        
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH시 mm분"
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        
        let completeTimeString = "\(components.year!)-\(components.month!)-\(components.day!) \(self)"
        
        return format.date(from: completeTimeString) ?? Date()

    }
}
