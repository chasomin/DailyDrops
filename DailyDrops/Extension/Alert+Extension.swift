//
//  Alert+Extension.swift
//  DailyDrops
//
//  Created by 차소민 on 3/12/24.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, action: @escaping ((UIAlertAction) -> Void)) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let ok = UIAlertAction(title: "확인", style: .default, handler: action)
        
        alert.addAction(cancel)
        alert.addAction(ok)
        
        alert.view.tintColor = .pointColor
        
        present(alert, animated: true)
    }
}
