//
//  UIButton+Extension.swift
//  DailyDrops
//
//  Created by 차소민 on 3/12/24.
//

import UIKit

extension UIButton {
    func isTapped(value: Bool = false, text: String) -> UIButton.Configuration {
        if value {
            var config = UIButton.Configuration.filled()
            config.cornerStyle = .capsule
            config.baseBackgroundColor = .pointColor
            config.baseForegroundColor = .titleColor
            var attr = AttributedString.init(text)
            attr.font = UIFont.body
            config.attributedSubtitle = attr
            return config

        } else {
            var config = UIButton.Configuration.filled()
            config.cornerStyle = .capsule
            config.baseBackgroundColor = .secondaryColor
            config.baseForegroundColor = .titleColor
            var attr = AttributedString.init(text)
            attr.font = UIFont.body
            config.attributedSubtitle = attr
            return config
        }
    }
}
