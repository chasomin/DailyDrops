//
//  SettingViewModel.swift
//  DailyDrops
//
//  Created by 차소민 on 3/20/24.
//

import Foundation

final class SettingViewModel {
    
    static let shared = SettingViewModel()
        
    private let repository = RealmRepository()
    
    let inputViewDidLoad: Observable<Constants.Setting?> = Observable(nil)
    let inputViewDidDisappear: Observable<(kind: Constants.Setting, goalValue: String?)?> = Observable(nil)
    let inputTextFieldValueChanged: Observable<String?> = Observable(nil)
    
    let outputGoal: Observable<Int?> = Observable(nil)
    let outputInvaild: Observable<String?> = Observable(nil)
    
    private init() { transform() }
    
    private func transform() {
        inputViewDidLoad.bind { [weak self] value in
            guard let self, let value else { return }
            fetchData(kind: value)
        }
        
        inputViewDidDisappear.bind { [weak self] value in
            guard let self, let value else { return }
            saveData(kind: value.kind, value: value.goalValue)
        }
        
        inputTextFieldValueChanged.bind { [weak self] value in
            guard let self, let text = value else { return }
            guard let step = Int(text) else {
                if !text.isEmpty {
                    outputInvaild.value = "숫자만 입력해주세요"
                }
                return
            }
            if step > 20000 {
                outputInvaild.value  = "최대 20,000 걸음까지 설정 가능해요"
            } else {
                
            }

        }
    }
    
    private func fetchData(kind: Constants.Setting) {
        switch kind {
        case .waterGoal:
            outputGoal.value = Int(repository.readGoalCups())
        case .stepGoal:
            outputGoal.value = repository.readGoalSteps()
        case .supplement:
            break
        case .notification:
            break
        }
    }
    
    private func saveData(kind: Constants.Setting, value: String?) {
        guard let text = value else { return }
        guard let goal = Int(text) else { return }

        let waterGoal = repository.readGoalCups()
        let stepGoal = repository.readGoalSteps()
        switch kind {
        case .waterGoal:
            if waterGoal != Float(goal) {
                repository.createItem(RealmGoal(waterCup: Float(goal), steps: stepGoal), completion: nil)
            }
        case .stepGoal:
            if stepGoal != goal {
                repository.createItem(RealmGoal(waterCup: waterGoal, steps: goal), completion: nil)
            }
        case .supplement:
            break
        case .notification:
            break
        }
    }
}
