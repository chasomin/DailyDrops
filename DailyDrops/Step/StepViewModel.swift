//
//  StepViewModel.swift
//  DailyDrops
//
//  Created by 차소민 on 3/17/24.
//

import Foundation

final class StepViewModel {    
    let inputViewDidLoad: Observable<Void?> = Observable(nil)
    let inputSegmentChanged: Observable<Int?> = Observable(nil)
    
    let outputSegmentChanged:  Observable<Int> = Observable(0)
    let outputWeekSteps: Observable<[Double]> = Observable([])
    let outputMonthSteps: Observable<[Double]> = Observable([])
    let outputTodaySteps: Observable<[Double]> = Observable([])
    
    init () { transform() }
    
    private func transform() {
        inputSegmentChanged.bind { [weak self] value in
            guard let self, let value else { return }
            outputSegmentChanged.value = value
        }
        
        inputViewDidLoad.bind { [weak self] _ in
            guard let self else { return }
            HealthManager.shared.getWeekStepCount { value, error  in
                guard let error else {
                    guard let value else { return }
                    self.outputWeekSteps.value = value
                    return
                }
            }
            HealthManager.shared.getMonthStepCount { value, error in
                guard let error else {
                    guard let value else { return }
                    self.outputMonthSteps.value = value
                    return
                }
            }
            HealthManager.shared.getOneDayHourlyStepCount { value, error in
                guard let error else {
                    guard let value else { return }
                    self.outputTodaySteps.value = value
                    return
                }
            }
        }
    }
}
