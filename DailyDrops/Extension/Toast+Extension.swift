//
//  Toast+Extension.swift
//  DailyDrops
//
//  Created by 차소민 on 3/14/24.
//

import UIKit
import Toast

extension UIViewController {
    func showToast(_ message: String, position: ToastPosition) {
        view.makeToast(message, duration: 2, position: position)

    }
}
