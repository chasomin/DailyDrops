//
//  WaterViewModel.swift
//  DailyDrops
//
//  Created by 차소민 on 3/11/24.
//

import Foundation

final class WaterViewModel {
    let repository = RealmRepository()
    let inputViewDidLoad: Observable<Date?> = Observable(nil)
    let inputPlusButtonTapped: Observable<Void?> = Observable(nil)
    let inputMinusButtonTapped: Observable<Void?> = Observable(nil)
    let inputViewDidDisappear: Observable<Void?> = Observable(nil)
    let inputViewWillAppear: Observable<Void?> = Observable(nil)
    
    let outputNotToday: Observable<Bool?> = Observable(nil)
    let outputViewDidLoad: Observable<(Float, Float)> = Observable((0, 0))
    let outputWaterCount: Observable<String?> = Observable(nil)
    let outputData: Observable<(data: Float?, goal: Float?)> = Observable((nil, nil))
    let outputViewDidDisappear: Observable<Void?> = Observable(nil)
    let outputViewWillAppear: Observable<Void?> = Observable(nil)
    let outputLabelHidden: Observable<Bool?> = Observable(nil)
    
    init() { transform() }
    
    private func transform() {
        inputViewDidLoad.bind { [weak self] value in
            guard let self, let value else { return }
            let data = repository.readWaterByDate(date: value)
            let goal = repository.readGoalCups(date: value)
            outputViewDidLoad.value = (data, goal)
            if checkCompletion() {
                outputLabelHidden.value = true
            } else {
                outputLabelHidden.value = false
            }
            
            if value.dateFormat() == Date().dateFormat() {
                outputNotToday.value = false
                outputWaterCount.value = "\(Int(goal - data))잔 남았어요!"

            } else {
                outputNotToday.value = true
                outputWaterCount.value = "총 \(Int(data))잔 마셨어요!"

            }
        }
        
        inputPlusButtonTapped.bind { [weak self] value in
            guard let self, let value else { return }
            if checkCompletion() {
                outputLabelHidden.value = true
            } else {
                repository.createItem(RealmWater(drinkWater: 1.0)) { [weak self] in
                    guard let self else { return }
                    guard let value = inputViewDidLoad.value else { return }
                    let data = repository.readWaterByDate(date: value)
                    let goal = repository.readGoalCups(date: value)
                    if checkCompletion() {
                        outputLabelHidden.value = true
                    } else {
                        outputLabelHidden.value = false
                    }
                    outputData.value = (data, goal)
                    outputWaterCount.value = "\(Int(goal - data))잔 남았어요!"
                }

            }
        }
        
        inputMinusButtonTapped.bind { [weak self] value in
            guard let self, let value else { return }
            outputLabelHidden.value = false
            if repository.readWaterByDate(date: Date()) > 0 {
                repository.createItem(RealmWater(drinkWater: -1.0), completion: nil)
                let data = repository.readWaterByDate(date: Date())
                let goal = repository.readGoalCups(date: Date())
                outputData.value = (data, goal)
                outputWaterCount.value = "\(Int(goal - data))잔 남았어요!"
            }
        }
        
        inputViewDidDisappear.bind { [weak self] value in
            guard let self, let value else { return }
            outputViewDidDisappear.value = ()
        }
        
        inputViewWillAppear.bind { [weak self] value in
            guard let self else { return }
            outputViewWillAppear.value = ()
        }
    }
    
    func checkCompletion() -> Bool {
        guard let date = inputViewDidLoad.value else { return false }
        if repository.readWaterByDate(date: date) == repository.readGoalCups(date: date) {
            return true
        } else {
            return false
        }
    }
}
