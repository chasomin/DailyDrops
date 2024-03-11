//
//  WaterViewModel.swift
//  DailyDrops
//
//  Created by 차소민 on 3/11/24.
//

import Foundation

final class WaterViewModel {
    let repository = RealmRepository()
    let inputViewDidLoad: Observable<Void?> = Observable(nil)
    let inputPlusButtonTapped: Observable<Void?> = Observable(nil)
    let inputMinusButtonTapped: Observable<Void?> = Observable(nil)

    let outputViewDidLoad: Observable<(Float, Float)> = Observable((0, 0))
    let outputData: Observable<(Float?, Float?)> = Observable((nil, nil))

    init() { transform() }
    
    private func transform() {
        inputViewDidLoad.bind { [weak self] _ in
            guard let self else { return }
            outputViewDidLoad.value = (repository.readWaterByDate(date: Date()), repository.readGoalCups())
            repository.createItem(RealmGoal(waterCup: 10.0, steps: 1000))//test
        }
        
        inputPlusButtonTapped.bind { [weak self] value in
            guard let self, let value else { return }
            guard let goal = repository.readGoal().last?.id else { return }
            repository.createItem(RealmWater(drinkWater: 1.0, goal: goal))
            outputData.value = (repository.readWaterByDate(date: Date()), repository.readGoalCups())
        }
        
        inputMinusButtonTapped.bind { [weak self] value in
            guard let self, let value else { return }
            guard let goal = repository.readGoal().last?.id else { return }
            repository.createItem(RealmWater(drinkWater: -1.0, goal: goal))
            outputData.value = (repository.readWaterByDate(date: Date()), repository.readGoalCups())
        }
    }
    
    
}
