//
//  Identifier.swift
//  DailyDrops
//
//  Created by 차소민 on 3/10/24.
//

import UIKit

extension UITableViewCell {
    static var id: String {
        self.description()
    }
}

extension UICollectionViewCell {
    static var id: String {
        self.description()
    }
}
