//
//  CapsulePointBarButton.swift
//  DailyDrops
//
//  Created by 차소민 on 3/11/24.
//

import UIKit

final class CapsulePointBarButton: UIButton {
    var text: String

    init(frame: CGRect, text: String) {
        self.text = text
        super.init(frame: frame)
        
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.baseBackgroundColor = .pointColor
        config.baseForegroundColor = .titleColor
        var attr = AttributedString.init(text)
        attr.font = UIFont.body
        config.attributedSubtitle = attr
        self.configuration = config
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}