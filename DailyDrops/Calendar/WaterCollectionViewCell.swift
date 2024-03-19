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
    let waterDetailMoveButton = MoveNextViewButton(kind: Constants.Topic.water, frame: .zero)
    
    override func configureHierarchy() {
        contentView.addSubview(waterView)
        contentView.addSubview(waterTitle)
        contentView.addSubview(waterDetailMoveButton)
    }
    
    override func configureLayout() {
        waterView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        waterTitle.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView).inset(15)
        }
        waterDetailMoveButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(contentView).inset(15)
            make.leading.equalTo(waterTitle.snp.trailing).offset(10)
            make.height.equalTo(waterTitle)
            make.width.equalTo(waterDetailMoveButton.snp.height)
        }
    }
    
    override func configureView() {
        waterView.startAnimation()
        waterTitle.text = Constants.Topic.water.rawValue
        waterTitle.font = .boldTitle
    }
    
    func configureCell(value: Float, selectedDate: Date?) {
        guard let selectedDate else { return }
        waterView.setProgress(value)
        if selectedDate.dateFormat() == Date().dateFormat() {
            waterDetailMoveButton.isHidden = false
        } else {
            waterDetailMoveButton.isHidden = true
        }
    }
    
    deinit {
        waterView.stopAnimation()
        print("=== water cell deinit")
    }
}
