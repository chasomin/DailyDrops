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
    
    func isTapped(name: String, time: String) -> UIButton.Configuration {
        
        let repository = RealmRepository()
        
        if repository.readSupplementLog().filter({ $0.supplementName == name && $0.supplementTime == time && $0.regDate.dateFormat() == Date().dateFormat() }).isEmpty {
            var config = UIButton.Configuration.plain()
            config.baseForegroundColor = .subTitleColor
            config.image = UIImage(systemName: "circle")
            config.buttonSize = .large
            return config
        } else {
            var config = UIButton.Configuration.plain()
            config.baseForegroundColor = .pointColor
            config.image = UIImage(systemName: "checkmark.circle.fill")
            config.buttonSize = .large
            return config
        }
    }
    
    static func setStatusCapsuleButton(status: Bool, text: String) -> UIButton.Configuration {
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.baseForegroundColor = .titleColor
        var attr = AttributedString.init(text)
        attr.font = UIFont.body
        config.attributedSubtitle = attr

        switch status {
        case true:
            config.baseBackgroundColor = .secondaryColor
            return config
        case false:
            config.baseBackgroundColor = .pointColor
            return config
        }
    }
}
