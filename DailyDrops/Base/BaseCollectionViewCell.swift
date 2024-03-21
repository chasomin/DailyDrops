//
//  BaseCollectionViewCell.swift
//  DailyDrops
//
//  Created by 차소민 on 3/7/24.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .backgroundColor

        configureHierarchy()
        configureLayout()
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
    }
    
    func configureLayout() {
    }
    
    func configureView() {
    }
}
