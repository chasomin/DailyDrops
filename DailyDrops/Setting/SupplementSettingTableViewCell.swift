//
//  SupplementSettingTableViewCell.swift
//  DailyDrops
//
//  Created by 차소민 on 3/20/24.
//

import UIKit
import SnapKit

class SupplementSettingTableViewCell: BaseTableViewCell {

    let nameLabel = UILabel()
    let daysLabel = UILabel()
    let timesLabel = UILabel()
    
    override func configureHierarchy() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(daysLabel)
        contentView.addSubview(timesLabel)
    }
    
    override func configureLayout() {
        nameLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(contentView).inset(15)
        }
        
        daysLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(contentView).inset(15)
        }
        timesLabel.snp.makeConstraints { make in
            make.top.equalTo(daysLabel.snp.bottom).offset(5)
            make.bottom.horizontalEdges.equalTo(contentView).inset(15)
        }
    }
    
    override func configureView() {
        selectionStyle = .none
        
        nameLabel.font = .boldBody
        
        daysLabel.font = .callout
        
        timesLabel.font = .callout
    }
    
    func configureCell(data: MySupplement) {
        nameLabel.text = data.name
        daysLabel.text = data.days.map{$0.transformDays()}.joined(separator: " / ")
            //"월/화/수/목/금"
        timesLabel.text = data.times.map{$0.dateFilterTime()}.joined(separator: " ∙ ")
        //"09시 00분 ∙ 12시 30분 ∙ 18시 00분"
    }

}

extension Int {
    func transformDays() -> String {
        switch self {
        case 1:
            return "일"
        case 2:
            return "월"
        case 3:
            return "화"
        case 4:
            return "수"
        case 5:
            return "목"
        case 6:
            return "금"
        case 7:
            return "토"
        default:
            return ""
        }
    }
}
