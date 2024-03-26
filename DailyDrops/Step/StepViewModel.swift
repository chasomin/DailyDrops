//
//  StepViewModel.swift
//  DailyDrops
//
//  Created by 차소민 on 3/17/24.
//

import Foundation

final class StepViewModel {    
    let repository = RealmRepository()
    
    let inputViewDidLoad: Observable<Date?> = Observable(nil)
    let inputSegmentChanged: Observable<Int> = Observable(0)
    
    let outputSegmentChanged: Observable<Int> = Observable(0)
    let outputTotalSteps: Observable<String?> = Observable(nil)
    let outputWeekSteps: Observable<[Double]> = Observable([])
    let outputMonthSteps: Observable<[Double]> = Observable([])
    let outputTodaySteps: Observable<[Double]> = Observable([])
    let outputGoal: Observable<Int?> = Observable(nil)
    
    init() { transform() }
    
    private func transform() {
        inputSegmentChanged.bind { [weak self] value in
            guard let self else { return }
            outputSegmentChanged.value = value
            getTotalSteps(segmentValue: value)
        }
        
        inputViewDidLoad.bind { [weak self] _ in
            guard let self else { return }
            guard let date = inputViewDidLoad.value else { return }

            outputGoal.value = repository.readGoalSteps(date: date)
            getTotalSteps(segmentValue: 0)
            HealthManager.shared.getWeekStepCount(date: date) { value, error  in
                guard let error else {
                    guard let value else { return }
                    self.outputWeekSteps.value = value
                    return
                }
            }
            HealthManager.shared.getMonthStepCount(date: date) { value, error in
                guard let error else {
                    guard let value else { return }
                    self.outputMonthSteps.value = value
                    return
                }
            }
            HealthManager.shared.getOneDayHourlyStepCount(date: date) { value, error in
                guard let error else {
                    guard let value else { return }
                    self.outputTodaySteps.value = value
                    return
                }
            }
        }
    }
    
    private func getTotalSteps(segmentValue: Int) {
        guard let date = inputViewDidLoad.value else { return }
        switch segmentValue {
        case 0:
            HealthManager.shared.getOneDayStepCount(today: date) { [weak self] value, error in
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
            HealthManager.shared.getAverageWeekStepCount(date: date) { [weak self] value, error in
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
            HealthManager.shared.getAverageMonthStepCount(date: date) { [weak self] value, error in
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
