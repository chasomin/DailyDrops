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
    
    let outputSetCalendar: Observable<Void?> = Observable(nil)
    let outputSetCollectionView: Observable<Void?> = Observable(nil)
    let outputAmountOfDrinksWater: Observable<Float> = Observable(0)
    let outputLeftSupplementCount: Observable<String> = Observable("")
    let outputSupplementProgress: Observable<Float> = Observable(0)
    let outputSteps: Observable<String> = Observable("")
    let outputStepsProgress: Observable<Float> = Observable(0)
    let outputReload: Observable<Int> = Observable(0)
    
    init() { transform() }

    private func transform() {
        inputViewDidLoad.bind { [weak self] value in
            guard let self, let value else { return }
            outputSetCalendar.value = ()
            outputSetCollectionView.value = ()
        }
        
        inputViewWillAppear.bind { [weak self] date in
            guard let self, let date else { return }
            getAmountOfDrinksWater(date: date)
            getLeftSupplementCount(date: date)
            getSteps(date: date)
        }
        
        inputSelectDate.bind { [weak self] date in
            guard let self, let date else { return }
            getAmountOfDrinksWater(date: date)
            getLeftSupplementCount(date: date)
            getSteps(date: date)
        }
    }
    
    private func getAmountOfDrinksWater(date: Date) {
        let goal = repository.readGoalCups()
        let drink = repository.readWaterByDate(date: date)
        outputAmountOfDrinksWater.value = drink / goal
        outputReload.value += 1
    }
    
    private func getLeftSupplementCount(date: Date) {
        let goal = repository.readSupplementByDate(date: date).count
        let intake = repository.readSupplementLog().filter{$0.regDate.dateFormat() == date.dateFormat()}.count
        
        switch goal {
        case 0:
            outputLeftSupplementCount.value = "오늘 복용할 영양제가 없어요"
            outputSupplementProgress.value = 1
        default :
            outputLeftSupplementCount.value = "\(goal - intake)개 남았어요!"
            outputSupplementProgress.value = Float(intake)/Float(goal)
        }
        outputReload.value += 1
    }
    
    private func getSteps(date: Date) {
        HealthManager.shared.getOneDayStepCount(today: date) { [weak self] value, error in
            guard let self else { return }
            let goal: Double = Double(repository.readGoalSteps())
            if let error {
                print(error)
            } else {
                guard let value else { return }
                
                outputSteps.value = "\(Int(value)) 걸음"
                outputStepsProgress.value = Float(value/goal)
                outputReload.value += 1
            }
        }
    }
    
}
