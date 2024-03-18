//
//  WaterCollectionViewCell.swift
//  DailyDrops
//
//  Created by 차소민 on 3/18/24.
//

import UIKit
import SnapKit
import WaveAnimationView

class WaterCollectionViewCell: BaseCollectionViewCell {
    lazy var waterView = WaveAnimationView(frame: CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height), frontColor: .backgroundColor, backColor: .pointColor)
    let waterTitle = UILabel()
    
    override func configureHierarchy() {
        contentView.addSubview(waterView)
        contentView.addSubview(waterTitle)
    }
    
    override func configureLayout() {
        waterView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        waterTitle.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(contentView).inset(15)
        }
    }
    
    override func configureView() {
        waterView.progress = 0.5
        waterView.startAnimation()
        
        waterTitle.text = "물 마시기"
        waterTitle.font = .boldTitle
    }
    
    deinit {
        waterView.stopAnimation()
        print("=== water cell deinit")
    }
}
