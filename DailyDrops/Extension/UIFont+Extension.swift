//
//  UIFont+Extension.swift
//  DailyDrops
//
//  Created by 차소민 on 3/7/24.
//

import UIKit

extension UIFont {
    static let largeBoldTitle = UIFont(name: "Pretendard-Bold", size: 34) ?? UIFont()
    
    static let boldTitle = UIFont(name: "Pretendard-Bold", size: 20) ?? UIFont()
    static let title = UIFont(name: "Pretendard-Regular", size: 20) ?? UIFont()
    
    static let boldBody = UIFont(name: "Pretendard-Bold", size: 16) ?? UIFont()
    static let body = UIFont(name: "Pretendard-Regular", size: 16) ?? UIFont()
    
    static let boldCallout = UIFont(name: "Pretendard-Bold", size: 13) ?? UIFont()
    static let callout = UIFont(name: "Pretendard-Regular", size: 13) ?? UIFont()
    
    static let caption = UIFont(name: "Pretendard-Regular", size: 11) ?? UIFont()
}
