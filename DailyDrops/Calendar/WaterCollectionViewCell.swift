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
            make.top.leading.equalTo(contentView).inset(15)
        }
    }
    
    override func configureView() {
        waterView.startAnimation()
        waterTitle.text = Constants.Topic.water.title
        waterTitle.font = .boldTitle
    }
    
    func configureCell(value: Float, selectedDate: Date?) {
        guard let selectedDate else { return }
        waterView.setProgress(value)
    }
    
    deinit {
        waterView.stopAnimation()
        print("=== water cell deinit")
    }
}
