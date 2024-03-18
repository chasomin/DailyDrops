//
//  SupplementLogCollectionViewCell.swift
//  DailyDrops
//
//  Created by 차소민 on 3/18/24.
//

import UIKit
import SnapKit

class SupplementLogCollectionViewCell: BaseCollectionViewCell {
    let supplementTitle = UILabel()
    let statusLabel = UILabel()
    let progressBar = UIProgressView()
    let nextNotificationLabel = UILabel()
    
    override func configureHierarchy() {
        contentView.addSubview(supplementTitle)
        contentView.addSubview(statusLabel)
        contentView.addSubview(progressBar)
        contentView.addSubview(nextNotificationLabel)
    }
    
    override func configureLayout() {
        supplementTitle.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(contentView).inset(15)
        }
        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(supplementTitle.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(contentView).inset(15)
        }
        nextNotificationLabel.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(contentView).inset(15)
        }
        progressBar.snp.makeConstraints { make in
            make.top.equalTo(nextNotificationLabel.snp.bottom).offset(15)
            make.height.equalTo(20)
            make.horizontalEdges.equalTo(contentView).inset(15)
            make.bottom.equalTo(contentView).inset(15)
        }
    }
    
    override func configureView() {
        supplementTitle.text = "영양제"
        supplementTitle.font = .boldTitle
        statusLabel.text = "2개 남았어요"
        statusLabel.font = .title
        nextNotificationLabel.text = "다음 알림 오후 9시"
        nextNotificationLabel.font = .body
        progressBar.tintColor = .pointColor
        progressBar.progress = 0.5
        
    }
}
