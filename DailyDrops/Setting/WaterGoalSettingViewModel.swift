//
//  WaterGoalSettingViewModel.swift
//  DailyDrops
//
//  Created by 차소민 on 3/21/24.
//

import Foundation

final class WaterGoalSettingViewModel {
    private let repository = RealmRepository()

    let inputGoalViewDidLoad: Observable<Void?> = Observable(nil)
    let inputGoalViewDidDisappear: Observable<String?> = Observable(nil)

    let outputGoal: Observable<Int?> = Observable(nil)

    init() { transform() }
    
    private func transform() {
        inputGoalViewDidLoad.bind { [weak self] value in
            guard let self, let value else { return }
            outputGoal.value = Int(repository.readGoalCups(date: Date()))
        }
        
        inputGoalViewDidDisappear.bind { [weak self] value in
            guard let self, let value else { return }
            saveData(value: value)
        }
    }

    
    private func saveData(value: String?) {
        guard let text = value else { return }
        guard let goal = Int(text) else { return }
        
        let waterGoal = repository.readGoalCups(date: Date())
        let stepGoal = repository.readGoalSteps(date: Date())
        if waterGoal != Float(goal) {
            repository.createItem(RealmGoal(waterCup: Float(goal), steps: stepGoal), completion: nil)
        }
    }
}
