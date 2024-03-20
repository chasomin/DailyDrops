//
//  SettingNotificationViewModel.swift
//  DailyDrops
//
//  Created by 차소민 on 3/12/24.
//

import Foundation

final class SettingNotificationViewModel {
    let repository = RealmRepository()
    
    let inputWeekButtonTapped: Observable<Int?> = Observable(nil)
    let inputSegmentTapped: Observable<Int> = Observable(0)
    let inputViewDidLoad: Observable<Void?> = Observable(nil)
    let inputSearchButtonTapped: Observable<Void?> = Observable(nil)
    let inputSaveButtonTapped: Observable<MySupplement?> = Observable(nil)
    
    let outputWeekButtonTapped:  Observable<[Int]> = Observable([])
    let outputSegmentTapped: Observable<Int> = Observable(0)
    let outputSetNavigation: Observable<Void?> = Observable(nil)
    let outputSearchButtonTapped: Observable<Void?> = Observable(nil)
    let outputSaveButtonTapped: Observable<Void?> = Observable(nil)
    let outputFailSave: Observable<String?> = Observable(nil)
    
    init () { transform() }
    
    private func transform() {
        inputWeekButtonTapped.bind { [weak self] value in
            guard let self, let value else { return }
            if outputWeekButtonTapped.value.contains(value) {
                guard let index = outputWeekButtonTapped.value.firstIndex(of: value) else { return }
                outputWeekButtonTapped.value.remove(at: index)
            } else {
                outputWeekButtonTapped.value.append(value)
            }
        }
        
        inputSegmentTapped.bind { [weak self] value in
            guard let self else { return }
            outputSegmentTapped.value = value
        }
        
        inputViewDidLoad.bind { [weak self] _ in
            guard let self else { return }
            outputSetNavigation.value = ()
        }
        
        inputSearchButtonTapped.bind { [weak self] value in
            guard let self, let value else { return }
            outputSearchButtonTapped.value = value
        }
        
        inputSaveButtonTapped.bind { [weak self] value in
            guard let self, let value else { return }
            checkSaveData(value)
        }
    }
    
    func checkSaveData(_ value: MySupplement) {
        guard !value.name.isEmpty && !value.days.isEmpty else {
            outputFailSave.value = "모든 항목을 입력해주세요!"
            return
        }
        
        var time: [Date] = []
        
        time = value.times[...outputSegmentTapped.value].map { $0 }.sorted()
        
        repository.createItem(MySupplement(id: value.id, regDate: Date(), name: value.name, days: value.days.sorted(), times: time).toDTO(), completion: nil)
        outputSaveButtonTapped.value = ()
        
    }
}
