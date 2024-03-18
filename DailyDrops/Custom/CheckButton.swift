//
//  CheckButton.swift
//  DailyDrops
//
//  Created by 차소민 on 3/17/24.
//

import UIKit

final class CheckButton: UIButton {

    var item: SupplementName

    init(item: SupplementName, frame: CGRect) {
        self.item = item
        super.init(frame: frame)
        
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .subTitleColor
        config.image = UIImage(systemName: "checkmark")
        self.configuration = config
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
