//
//  SupplementCollectionViewCell.swift
//  DailyDrops
//
//  Created by 차소민 on 3/13/24.
//

import UIKit
import SnapKit

final class SupplementCollectionViewCell: BaseCollectionViewCell {
    let nameLabel = UILabel()
    let checkButton = UIButton()
    
    override func configureHierarchy() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(checkButton)
    }
    
    override func configureLayout() {
        nameLabel.snp.makeConstraints { make in
            make.verticalEdges.leading.equalTo(contentView.safeAreaLayoutGuide).inset(10)
        }
        
        checkButton.snp.makeConstraints { make in
            make.verticalEdges.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.width.equalTo(checkButton.snp.height)
        }
    }
    
    override func configureView() {
        nameLabel.font = .body
        nameLabel.textAlignment = .left
        nameLabel.numberOfLines = 1
        nameLabel.textColor = .titleColor
        
        checkButton.backgroundColor = .red//test
    }
}
