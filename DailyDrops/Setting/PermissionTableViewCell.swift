//
//  PermissionTableViewCell.swift
//  DailyDrops
//
//  Created by 차소민 on 3/23/24.
//

import UIKit
import SnapKit

class PermissionTableViewCell: BaseTableViewCell {

    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let permissionSwitch = UISwitch()
    
    override func configureHierarchy() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(permissionSwitch)
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView).inset(15)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.leading.bottom.equalTo(contentView).inset(15)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
        permissionSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.trailing.equalTo(contentView).inset(15)
            make.leading.equalTo(descriptionLabel.snp.trailing).offset(10)
        }

    }

    override func configureView() {
        selectionStyle = .none
        titleLabel.font = .body
        
        descriptionLabel.font = .caption
        descriptionLabel.numberOfLines = 0
        
        permissionSwitch.onTintColor = .pointColor
    }
    
    
    func configureCell(index: Int) {
        titleLabel.text = Constants.Permission.allCases[index].title
        descriptionLabel.text = Constants.Permission.allCases[index].description
        permissionSwitch.tag = index

        switch index {
        case 0:
            NotificationManager.shared.checkNotificationAuthorization { [weak self] value in
                guard let self else { return }
                DispatchQueue.main.async {
                    self.permissionSwitch.isOn = value
                }
            }
        case 1:
            permissionSwitch.isHidden = true
        default: break
        }
    }
}
