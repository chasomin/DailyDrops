//
//  SearchTableViewCell.swift
//  DailyDrops
//
//  Created by 차소민 on 3/10/24.
//

import UIKit
import SnapKit

class SearchTableViewCell: BaseTableViewCell {
    
    let corporateNameLabel = UILabel()
    let supplementNameLabel = UILabel()
    let shapeLabel = UILabel()
    
    override func configureHierarchy() {
        contentView.addSubview(corporateNameLabel)
        contentView.addSubview(supplementNameLabel)
        contentView.addSubview(shapeLabel)
    }
    
    override func configureLayout() {
        corporateNameLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(15)
        }
        supplementNameLabel.snp.makeConstraints { make in
            make.top.equalTo(corporateNameLabel.snp.bottom).offset(10)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(15)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(10)
        }
        shapeLabel.snp.makeConstraints { make in
            make.top.equalTo(supplementNameLabel)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(15)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(10)
        }
        
    }
    
    override func configureView() {
        corporateNameLabel.font = .callout
        supplementNameLabel.font = .body
        shapeLabel.font = .body
        shapeLabel.textAlignment = .right
        
        //test
        corporateNameLabel.text = "제조사"
        supplementNameLabel.text = "약 이름"
        shapeLabel.text = "캡슐"
    }

}
