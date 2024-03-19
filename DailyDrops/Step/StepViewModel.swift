//
//  StepViewModel.swift
//  DailyDrops
//
//  Created by 차소민 on 3/17/24.
//

import Foundation

final class StepViewModel {
    let inputSegmentChanged: Observable<Int?> = Observable(nil)
    let inputViewWillAppear: Observable<Void?> = Observable(nil)
    
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
        
        inputViewWillAppear.bind { [weak self] _ in
            guard let self else { return }
            HealthManager.shared.getWeekStepCount { value, error  in
                if let error {
                    //TODO: ERROR
                } else {
                    guard let value else { return }
                    self.outputWeekSteps.value = value
                }
            }
            HealthManager.shared.getMonthStepCount { value, error in
                if let error {
                    
                } else {
                    guard let value else { return }
                    self.outputMonthSteps.value = value
                }

            }
            HealthManager.shared.getOneDayHourlyStepCount { value, error in
                if let error {
                    
                } else {
                    guard let value else { return }
                    self.outputTodaySteps.value = value
                }

            }
        }
    }
}
