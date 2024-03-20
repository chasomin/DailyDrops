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
    
    let inputGoalViewDidLoad: Observable<Constants.Setting?> = Observable(nil)
    let inputGoalViewDidDisappear: Observable<(kind: Constants.Setting, goalValue: String?)?> = Observable(nil)
    let inputTextFieldValueChanged: Observable<String?> = Observable(nil)
    let inputSupplementViewDidLoad: Observable<Void?> = Observable(nil)
    let inputSupplementDeleteAction: Observable<MySupplement?> = Observable(nil)
    
    let outputGoal: Observable<Int?> = Observable(nil)
    let outputInvaild: Observable<String?> = Observable(nil)
    let outputSupplement: Observable<[MySupplement]?> = Observable(nil)
    
    private init() { transform() }
    
    private func transform() {
        inputGoalViewDidLoad.bind { [weak self] value in
            guard let self, let value else { return }
            fetchData(kind: value)
        }
        
        inputGoalViewDidDisappear.bind { [weak self] value in
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
        
        inputSupplementViewDidLoad.bind { [weak self] value in
            guard let self, let value else { return }
            outputSupplement.value = repository.readSupplement()
        }
        
        inputSupplementDeleteAction.bind { [weak self] value in
            guard let self, let value else { return }
            repository.deleteSupplement(id: value.id) {
                self.outputSupplement.value = self.repository.readSupplement()
            }
        }
    }
    
    private func fetchData(kind: Constants.Setting) {
        switch kind {
        case .waterGoal:
            outputGoal.value = Int(repository.readGoalCups(date: Date()))
        case .stepGoal:
            outputGoal.value = repository.readGoalSteps(date: Date())
        case .supplement:
            break
        case .notification:
            break
        }
    }
    
    private func saveData(kind: Constants.Setting, value: String?) {
        guard let text = value else { return }
        guard let goal = Int(text) else { return }

        let waterGoal = repository.readGoalCups(date: Date())
        let stepGoal = repository.readGoalSteps(date: Date())
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
