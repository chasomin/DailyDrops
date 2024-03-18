//
//  StepCollectionViewCell.swift
//  DailyDrops
//
//  Created by 차소민 on 3/18/24.
//

import UIKit
import SnapKit

class StepCollectionViewCell: BaseCollectionViewCell {
    let stepsTitle = UILabel()
    let statusLabel = UILabel()
    let progressBar = UIProgressView()
    let descriptionLabel = UILabel()
    
    override func configureHierarchy() {
        contentView.addSubview(stepsTitle)
        contentView.addSubview(statusLabel)
        contentView.addSubview(progressBar)
        contentView.addSubview(descriptionLabel)
    }
    
    override func configureLayout() {
        stepsTitle.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(contentView).inset(15)
        }
        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(stepsTitle.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(contentView).inset(15)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(contentView).inset(15)
        }
        progressBar.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(15)
            make.height.equalTo(20)
            make.horizontalEdges.equalTo(contentView).inset(15)
            make.bottom.equalTo(contentView).inset(15)
        }
    }
    
    override func configureView() {
        stepsTitle.text = "걸음 수"
        stepsTitle.font = .boldTitle
        statusLabel.text = "4049 걸음"
        statusLabel.font = .title
        descriptionLabel.text = "어제보다 900 걸음 덜 걸었어요"
        descriptionLabel.font = .body
        progressBar.tintColor = .pointColor
        progressBar.progress = 0.4
        
    }
}
