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
    let outputSegmentTapped: Observable<Int?> = Observable(nil)
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
    
    func checkSaveData(_ value:  MySupplement) {
        if value.name.isEmpty || value.days.isEmpty {
            outputFailSave.value = "모든 항목을 입력해주세요!"
        } else {
            var time: [Date] = []
            if outputSegmentTapped.value == 0 {
                time = [value.times[0]]
            } else if outputSegmentTapped.value == 1 {
                time = [value.times[0], value.times[1]].sorted()
            } else {
                time = value.times.sorted()
            }
            repository.createItem(MySupplement(name: value.name, days: value.days, times: time).toDTO(), completion: nil)
            outputSaveButtonTapped.value = ()
        }
    }
}
