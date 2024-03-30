//
//  StepGoalSettingViewModel.swift
//  DailyDrops
//
//  Created by 차소민 on 3/21/24.
//

import Foundation

final class StepGoalSettingViewModel {
    private let repository = RealmRepository()

    let inputGoalViewDidLoad: Observable<Void?> = Observable(nil)
    let inputGoalViewDidDisappear: Observable<String?> = Observable(nil)
    let inputTextFieldValueChanged: Observable<String?> = Observable(nil)

    let outputGoal: Observable<Int?> = Observable(nil)
    let outputInvalid: Observable<String?> = Observable(nil)

    init() { transform() }
    
    private func transform() {
        inputGoalViewDidLoad.bind { [weak self] value in
            guard let self, let value else { return }
            outputGoal.value = repository.readGoalSteps(date: Date())
        }
        
        inputGoalViewDidDisappear.bind { [weak self] value in
            guard let self, let value else { return }
            saveData(value: value)
        }
        
        inputTextFieldValueChanged.bind { [weak self] value in
            guard let self, let text = value else { return }
            guard let step = Int(text) else {
                if !text.isEmpty {
                    outputInvalid.value = "숫자만 입력해주세요"
                }
                return
            }
            if step > 20000 {
                outputInvalid.value  = "최대 20,000 걸음까지 설정 가능해요"
            } else {
                
            }
        }
    }
    
    private func saveData(value: String?) {
        guard let text = value else { return }
        guard let goal = Int(text) else { return }
        
        let waterGoal = repository.readGoalCups(date: Date())
        let stepGoal = repository.readGoalSteps(date: Date())
        if stepGoal != goal {
            repository.createItem(RealmGoal(waterCup: waterGoal, steps: goal), completion: nil)
        }
    }
    
}
