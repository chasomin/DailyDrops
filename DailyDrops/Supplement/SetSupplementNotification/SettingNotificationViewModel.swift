//
//  SettingNotificationViewModel.swift
//  DailyDrops
//
//  Created by 차소민 on 3/12/24.
//

import Foundation

final class SettingNotificationViewModel {
    let inputWeekButtonTapped: Observable<Int?> = Observable(nil)
    
    let outputWeekButtonTapped:  Observable<[Int]> = Observable([])
    
    init () { transform() }
    
    private func transform() {
        inputWeekButtonTapped.bind { [weak self] value in
            guard let self, let value else { return }
            if outputWeekButtonTapped.value.contains(value) {
                guard let index = outputWeekButtonTapped.value.firstIndex(of: value) else { return }
                outputWeekButtonTapped.value.remove(at: index)
            } else {
                outputWeekButtonTapped.value.append(value)
            }
        }
    }
}
