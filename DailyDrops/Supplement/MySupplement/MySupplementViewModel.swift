//
//  MySupplementViewModel.swift
//  DailyDrops
//
//  Created by 차소민 on 3/14/24.
//

import Foundation

final class MySupplementViewModel {
    let repository = RealmRepository()
    
    let inputViewDidLoad: Observable<Void?> = Observable(nil)
    let inputViewWillAppear: Observable<Void?> = Observable(nil)
    
    let outputViewDidLoad: Observable<Void?> = Observable(nil)
    let outputSetNavigation: Observable<Void?> = Observable(nil)
    let outputSection: Observable<[String]> = Observable([])
    let outputSupplementData : Observable<[String:[SupplementName]]?> = Observable(nil)
    
    
    init() {
        transform()
    }
    
    private func transform() {
        inputViewDidLoad.bind { [weak self] _ in
            guard let self else { return }
            outputSetNavigation.value = ()
            outputViewDidLoad.value = ()
        }
        inputViewWillAppear.bind { [weak self] value in
            guard let self else { return }
            outputSection.value = repository.readTodaySupplementTime()
            guard let value else { return }
            outputSupplementData.value = [:]
            setTodaySupplementForTime()
        }
    }
    
    private func setTodaySupplementForTime() {
        outputSection.value.forEach {
            outputSupplementData.value?.updateValue(repository.readSupplementForTime($0).map{ SupplementName(name:$0.name) }, forKey: $0)
        }
    }
}
