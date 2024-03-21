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
    let stepDetailMoveButton = MoveNextViewButton(kind: Constants.Topic.step, frame: .zero)

    override func configureHierarchy() {
        contentView.addSubview(stepsTitle)
        contentView.addSubview(statusLabel)
        contentView.addSubview(progressBar)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(stepDetailMoveButton)
    }
    
    override func configureLayout() {
        stepsTitle.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView).inset(15)
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
        stepDetailMoveButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(contentView).inset(15)
            make.leading.equalTo(stepsTitle.snp.trailing).offset(10)
            make.height.equalTo(stepsTitle)
            make.width.equalTo(stepDetailMoveButton.snp.height)
        }
    }
    
    override func configureView() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.secondaryBackgroundColor.cgColor
        
        stepsTitle.text = Constants.Topic.step.title
        stepsTitle.font = .boldTitle
        statusLabel.font = .body
//        descriptionLabel.text = "어제보다 900 걸음 덜 걸었어요"
        descriptionLabel.font = .body
        progressBar.tintColor = .pointColor
        progressBar.clipsToBounds = true
        progressBar.layer.cornerRadius = 10
    }
    
    func configureCell(text: String, value: Float, selectedDate: Date?) {
        guard let selectedDate else { return }
        statusLabel.text = text
        progressBar.progress = value
        if selectedDate.dateFormat() == Date().dateFormat() {
            stepDetailMoveButton.isHidden = false
        } else {
            stepDetailMoveButton.isHidden = true
        }
    }
}
