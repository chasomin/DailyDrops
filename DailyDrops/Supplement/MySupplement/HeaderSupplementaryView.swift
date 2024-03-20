//
//  HeaderSupplementaryView.swift
//  DailyDrops
//
//  Created by 차소민 on 3/13/24.
//

import UIKit
import SnapKit

final class HeaderSupplementaryView: UICollectionReusableView {
    static let id = HeaderSupplementaryView.description()
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
            make.bottom.leading.equalTo(safeAreaLayoutGuide)
            make.top.equalTo(safeAreaLayoutGuide).inset(10)
        }
    }
    
    private func configureView() {
        label.font = .boldBody
        label.textColor = .subTitleColor
        label.backgroundColor = .secondaryColor
    }
}
