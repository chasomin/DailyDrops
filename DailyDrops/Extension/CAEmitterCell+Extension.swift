//
//  CAEmitterCell+Extension.swift
//  DailyDrops
//
//  Created by 차소민 on 3/22/24.
//

import UIKit

extension CAEmitterCell {
    func setEmitterCell(image: UIImage, birth: Float, scale: CGFloat) {
        self.contents = image.cgImage

        self.lifetime = 3
        self.birthRate = birth
        
        self.scale = scale
        self.scaleRange = 0.4
        
        self.spin = 10
        self.spinRange = 30
        
        self.emissionRange = CGFloat.pi
        self.velocity = 1000
        self.velocityRange = 1000
        self.yAcceleration = 1000
    }
}
