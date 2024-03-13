//
//  HeaderSupplementaryView.swift
//  DailyDrops
//
//  Created by 차소민 on 3/13/24.
//

import UIKit
import SnapKit

final class TitleSupplementaryView: UICollectionReusableView {
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        addSubview(label)
    }
    
    private func configureLayout() {
        label.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    private func configureView() {
        label.font = .boldCallout
        label.textColor = .subTitleColor
    }
}
