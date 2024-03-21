//
//  CalendarViewModel.swift
//  DailyDrops
//
//  Created by 차소민 on 3/19/24.
//

import Foundation

final  class CalendarViewModel {
    private let repository = RealmRepository()
    
    let inputViewDidLoad: Observable<Void?> = Observable(nil)
    let inputViewWillAppear: Observable<Date?> = Observable(nil)
    let inputSelectDate: Observable<Date?> = Observable(nil)
    
    let outputViewDidLoad: Observable<Void?> = Observable(nil)
    let outputSetCalendar: Observable<Void?> = Observable(nil)
    let outputAmountOfDrinksWater: Observable<Float> = Observable(0)
    let outputLeftSupplementCount: Observable<String> = Observable("")
    let outputSupplementProgress: Observable<Float> = Observable(0)
    let outputSteps: Observable<String> = Observable("")
    let outputStepsProgress: Observable<Float> = Observable(0)
    let outputReload: Observable<Int> = Observable(0)
    let outputFutureDate: Observable<String?> = Observable(nil)
    let outputNotToday: Observable<Bool?> = Observable(nil)
    
    init() { transform() }

    private func transform() {
        inputViewDidLoad.bind { [weak self] value in
            guard let self, let value else { return }
            outputSetCalendar.value = ()
            outputViewDidLoad.value = ()
        }
        
        inputViewWillAppear.bind { [weak self] date in
            guard let self, let date else { return }
            getAmountOfDrinksWater(date: date)
            getLeftSupplementCount(date: date)
            getSteps(date: date)
        }
        
        inputSelectDate.bind { [weak self] date in
            guard let self, let date else { return }
            if date > Date() {
                getAmountOfDrinksWater(date: Date())
                getLeftSupplementCount(date: Date())
                getSteps(date: Date())
                outputFutureDate.value = "미래의 날짜는 선택할 수 없어요"
            } else {
                getAmountOfDrinksWater(date: date)
                getLeftSupplementCount(date: date)
                getSteps(date: date)
            }
            
            if date < Date().dateWithMidnight() {
                outputNotToday.value = false
            } else {
                outputNotToday.value = true
            }
        }
    }
    
    private func getAmountOfDrinksWater(date: Date) {
        let goal = repository.readGoalCups(date: date)
        let drink = repository.readWaterByDate(date: date)
        print("==", goal)
        if goal == 0 {
            outputAmountOfDrinksWater.value = 1
        } else {
            outputAmountOfDrinksWater.value = drink / goal
        }
        outputReload.value += 1
    }
    
    private func getLeftSupplementCount(date: Date) {
        let supplementTimes = repository.readSupplementByDate(date: date).map{$0.times.count}
        let goal = supplementTimes.reduce(0, +)
        let intake = repository.readSupplementLog().filter{$0.regDate.dateFormat() == date.dateFormat()}.count
        
        switch goal {
        case 0:
            outputLeftSupplementCount.value = "오늘 복용할 영양제가 없어요"
            outputSupplementProgress.value = 1
        default :
            if date < Date().dateWithMidnight() {
                outputLeftSupplementCount.value = "\(Int((Float(intake)/Float(goal))*100))% 완료!"
                outputSupplementProgress.value = Float(intake)/Float(goal)
            } else {
                outputLeftSupplementCount.value = "\(goal - intake)개 남았어요!"
                outputSupplementProgress.value = Float(intake)/Float(goal)
            }
        }
        outputReload.value += 1
    }
    
    private func getSteps(date: Date) {
        let goal: Double = Double(repository.readGoalSteps(date: date))
        HealthManager.shared.getOneDayStepCount(today: date) { [weak self] value, error in
            guard let self else { return }
            guard let error else {
                guard let value else { return }
                if goal == 0 {
                    outputSteps.value = "\(Int(value)) 걸음"
                    outputStepsProgress.value = 1
                } else {
                    outputSteps.value = "\(Int(value)) 걸음"
                    outputStepsProgress.value = Float(value/goal)
                }
                outputReload.value += 1
                return
            }
            // 12시라서 걸음수가 없다면??
            outputSteps.value = "\(Int(0)) 걸음"
            outputStepsProgress.value = Float(0)
            outputReload.value += 1
        }
    }
}
