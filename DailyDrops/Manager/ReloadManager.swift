//
//  ReloadManager.swift
//  DailyDrops
//
//  Created by 차소민 on 3/23/24.
//

import Foundation

final class ReloadManager {
    static let shared = ReloadManager()
    
    private init() { }
    
    weak var delegate: ReloadProtocol?
    
    func didBecomeActive() {
        delegate?.didBecomeActive()
    }
}
