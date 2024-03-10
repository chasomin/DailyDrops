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
            make.leading.equalTo(supplementNameLabel.snp.trailing).offset(10)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(15)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(10)
        }
    }
    
    override func configureView() {
        corporateNameLabel.font = .callout
        corporateNameLabel.textColor = .subTitleColor
        supplementNameLabel.font = .body
        shapeLabel.font = .body
        shapeLabel.textAlignment = .right
        shapeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        selectionStyle = .none
    }
    
    func configureCell(data: Supplement) {
        corporateNameLabel.text = data.corporateName
        supplementNameLabel.text = data.supplementName
        shapeLabel.text = data.shape
    }

}
