//
//  MoveNextViewButton.swift
//  DailyDrops
//
//  Created by 차소민 on 3/19/24.
//

import UIKit

final class MoveNextViewButton: UIButton {
    
    let kind: Constants.Topic
    
    init(kind: Constants.Topic, frame: CGRect) {
        self.kind = kind
        super.init(frame: frame)
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .secondaryColor
        config.baseForegroundColor = .pointColor
        config.cornerStyle = .capsule
        config.image = UIImage(systemName: "chevron.forward")
        self.configuration = config
        self.layer.shadowColor = UIColor.subTitleColor.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 2
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



