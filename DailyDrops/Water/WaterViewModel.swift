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
    let inputViewDidDisappear: Observable<Void?> = Observable(nil)
    let inputViewWillAppear: Observable<Void?> = Observable(nil)
    
    let outputViewDidLoad: Observable<(Float, Float)> = Observable((0, 0))
    let outputData: Observable<(data: Float?, goal: Float?)> = Observable((nil, nil))
    let outputViewDidDisappear: Observable<Void?> = Observable(nil)
    let outputViewWillAppear: Observable<Void?> = Observable(nil)
    let outputLabelHidden: Observable<Bool?> = Observable(nil)
    
    init() { transform() }
    
    private func transform() {
        inputViewDidLoad.bind { [weak self] _ in
            guard let self else { return }
            outputViewDidLoad.value = (repository.readWaterByDate(date: Date()), repository.readGoalCups(date: Date()))
            if checkCompletion() {
                outputLabelHidden.value = true
            } else {
                outputLabelHidden.value = false
            }
        }
        
        inputPlusButtonTapped.bind { [weak self] value in
            guard let self, let value else { return }
            if checkCompletion() {
                outputLabelHidden.value = true
            } else {
                repository.createItem(RealmWater(drinkWater: 1.0)) { [weak self] in
                    guard let self else { return }
                    if checkCompletion() {
                        outputLabelHidden.value = true
                        outputData.value = (repository.readWaterByDate(date: Date()), repository.readGoalCups(date: Date()))
                    } else {
                        outputLabelHidden.value = false
                        outputData.value = (repository.readWaterByDate(date: Date()), repository.readGoalCups(date: Date()))
                    }
                }

            }
        }
        
        inputMinusButtonTapped.bind { [weak self] value in
            guard let self, let value else { return }
            outputLabelHidden.value = false
            if repository.readWaterByDate(date: Date()) > 0 {
                repository.createItem(RealmWater(drinkWater: -1.0), completion: nil)
                outputData.value = (repository.readWaterByDate(date: Date()), repository.readGoalCups(date: Date()))
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
        if repository.readWaterByDate(date: Date()) == repository.readGoalCups(date: Date()) {
            return true
        } else {
            return false
        }
    }
}
