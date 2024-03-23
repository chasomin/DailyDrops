//
//  EmptyView.swift
//  DailyDrops
//
//  Created by 차소민 on 3/23/24.
//

import UIKit
import SnapKit

class EmptyView: BaseView {
    let imageView = UIImageView()
    let label = UILabel()
    
    init(image: UIImage, text: String, frame: CGRect) {
        imageView.image = image
        label.text = text
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        addSubview(imageView)
        addSubview(label)
    }
    
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().dividedBy(2)
            make.width.equalTo(self.snp.width).dividedBy(4)
            make.height.equalTo(imageView.snp.width)
        }
        label.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(40)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(15)
        }
    }
    
    override func configureView() {
        label.numberOfLines = 0
        label.font = .boldBody
        label.textAlignment = .center
    }
}
