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
    let supplementDetailMoveButton = MoveNextViewButton(kind: Constants.Topic.supplement, frame: .zero)
    
    override func configureHierarchy() {
        contentView.addSubview(supplementTitle)
        contentView.addSubview(statusLabel)
        contentView.addSubview(progressBar)
        contentView.addSubview(nextNotificationLabel)
        contentView.addSubview(supplementDetailMoveButton)
    }
    
    override func configureLayout() {
        supplementTitle.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView).inset(15)
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
        supplementDetailMoveButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(contentView).inset(15)
            make.leading.equalTo(supplementTitle.snp.trailing).offset(10)
            make.height.equalTo(supplementTitle)
            make.width.equalTo(supplementDetailMoveButton.snp.height)
        }
    }
    
    override func configureView() {
        supplementTitle.text = Constants.Topic.supplement.rawValue
        supplementTitle.font = .boldTitle
        statusLabel.font = .title
//        nextNotificationLabel.text = "다음 알림 오후 9시"
        nextNotificationLabel.font = .body
        progressBar.tintColor = .pointColor        
    }
    
    func configureCell(text: String, value: Float, selectedDate: Date?) {
        guard let selectedDate else { return }
        statusLabel.text = text
        progressBar.progress = value
        
        if selectedDate.dateFormat() == Date().dateFormat() {
            supplementDetailMoveButton.isHidden = false
        } else {
            supplementDetailMoveButton.isHidden = true
        }
    }
}
