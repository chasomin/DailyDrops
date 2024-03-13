//
//  SettingNotificationViewModel.swift
//  DailyDrops
//
//  Created by 차소민 on 3/12/24.
//

import Foundation

final class SettingNotificationViewModel {
    let inputWeekButtonTapped: Observable<Int?> = Observable(nil)
    let inputSegmentTapped: Observable<Int> = Observable(0)
    let inputViewDidLoad: Observable<Void?> = Observable(nil)
    let inputSearchButtonTapped: Observable<Void?> = Observable(nil)
    
    let outputWeekButtonTapped:  Observable<[Int]> = Observable([])
    let outputSegmentTapped: Observable<Int?> = Observable(nil)
    let outputSetNavigation: Observable<Void?> = Observable(nil)
    let outputSearchButtonTapped: Observable<Void?> = Observable(nil)
    
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
        
        inputSegmentTapped.bind { [weak self] value in
            guard let self else { return }
            outputSegmentTapped.value = value
        }
        
        inputViewDidLoad.bind { [weak self] _ in
            guard let self else { return }
            outputSetNavigation.value = ()
        }
        
        inputSearchButtonTapped.bind { [weak self] value in
            guard let self, let value else { return }
            outputSearchButtonTapped.value = value
        }
    }
}
