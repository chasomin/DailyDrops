//
//  UIColor+Extension.swift
//  DailyDrops
//
//  Created by 차소민 on 3/7/24.
//

import UIKit

extension UIColor {
    static let pointColor = UIColor(red: 48/255, green: 176/255, blue: 199/255, alpha: 1)
    static let secondaryColor = UIColor(red: 252/255, green: 249/255, blue: 187/255, alpha: 1)
    static let backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    static let secondaryBackgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1)
    static let titleColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    static let subTitleColor = UIColor.gray
}

extension UIColor {
    static func setStatusColor(status: Bool) -> UIColor {
        switch status {
        case true:
            return UIColor.secondaryColor
        case false:
            return UIColor.pointColor
        }
    }
}
