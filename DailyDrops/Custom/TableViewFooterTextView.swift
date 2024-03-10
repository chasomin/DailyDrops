//
//  TableViewFooterTextView.swift
//  DailyDrops
//
//  Created by 차소민 on 3/11/24.
//

import UIKit
import SnapKit

final class TableViewFooterTextView: BaseView {
    var text: String
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = text
        label.font = .caption
        label.textColor = .subTitleColor
        label.backgroundColor = .backgroundColor
        label.textAlignment = .right
        return label
    }()
    
    init(frame: CGRect, text: String) {
        self.text = text
        super.init(frame: frame)
    }
    
    override func configureHierarchy() {
        addSubview(label)
    }
    
    override func configureLayout() {
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
