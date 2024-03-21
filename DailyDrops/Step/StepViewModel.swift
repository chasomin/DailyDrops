//
//  StepViewModel.swift
//  DailyDrops
//
//  Created by 차소민 on 3/17/24.
//

import Foundation

final class StepViewModel {    
    let repository = RealmRepository()
    
    let inputViewDidLoad: Observable<Void?> = Observable(nil)
    let inputSegmentChanged: Observable<Int> = Observable(0)
    
    let outputSegmentChanged: Observable<Int> = Observable(0)
    let outputTotalSteps: Observable<String?> = Observable(nil)
    let outputWeekSteps: Observable<[Double]> = Observable([])
    let outputMonthSteps: Observable<[Double]> = Observable([])
    let outputTodaySteps: Observable<[Double]> = Observable([])
    let outputGoal: Observable<Int?> = Observable(nil)
    
    init () { transform() }
    
    private func transform() {
        inputSegmentChanged.bind { [weak self] value in
            guard let self else { return }
            outputSegmentChanged.value = value
            
                getTotalSteps(segmentValue: value)
            
        }
        
        inputViewDidLoad.bind { [weak self] _ in
            guard let self else { return }
            
            outputGoal.value = repository.readGoalSteps(date: Date())
            
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
    
    private func getTotalSteps(segmentValue: Int) {
        switch segmentValue {
        case 0:
            HealthManager.shared.getOneDayStepCount(today: Date()) { [weak self] value, error in
                guard let self else { return }
                guard let error else {
                    guard let value else { return }
                    outputTotalSteps.value = "총 \(Int(value))걸음"
                    return
                }
                outputTotalSteps.value = "총 0걸음"
                print(error)
            }
        case 1:
            HealthManager.shared.getAverageWeekStepCount { [weak self] value, error in
                guard let self else { return }
                guard let error else {
                    guard let value else { return }
                    
                    outputTotalSteps.value = "평균 \(Int(value))걸음"
                    return
                }
                outputTotalSteps.value = "평균 0걸음"
                print(error)
            }
        case 2:
            HealthManager.shared.getAverageMonthStepCount { [weak self] value, error in
                guard let self else { return }
                guard let error else {
                    guard let value else { return }
                    
                    outputTotalSteps.value = "평균 \(Int(value))걸음"
                    return
                }
                outputTotalSteps.value = "평균 0걸음"
                print(error)
            }
        default:
            break
        }
    }
}
