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
    let inputCheckButtonTapped: Observable<(section: String, supplement: String)?> = Observable(nil)
    
    let outputSetNavigation: Observable<Void?> = Observable(nil)
    let outputSection: Observable<[String]> = Observable([])
    let outputSupplementData : Observable<[String:[SupplementName]]?> = Observable(nil)
    let outputCheckButtonTapped: Observable<Void?> = Observable(nil)
    
    init() {
        transform()
    }
    
    private func transform() {
        inputViewDidLoad.bind { [weak self] _ in
            guard let self else { return }
            outputSetNavigation.value = ()
        }
        inputViewWillAppear.bind { [weak self] value in
            guard let self else { return }
            outputSection.value = repository.readTodaySupplementTime()
            guard let value else { return }
            outputSupplementData.value = [:]
            setTodaySupplementForTime()
        }
        inputCheckButtonTapped.bind { [weak self] value in
            guard let self, let value else { return }
            
            if repository.readSupplementLog().filter({ $0.supplementName == value.supplement && $0.supplementTime == value.section && $0.regDate.dateFormat() == Date().dateFormat() }).isEmpty {
                repository.createItem(RealmSupplementLog(supplementName: value.supplement, supplementTime: value.section), completion: nil)
                outputCheckButtonTapped.value = ()
            } else {
                repository.deleteSupplementLog(date: Date().dateFormat(), name: value.supplement, time: value.section)
                outputCheckButtonTapped.value = ()
            }
        }
    }
    
    private func setTodaySupplementForTime() {
        outputSection.value.forEach {
            outputSupplementData.value?.updateValue(repository.readSupplementForTime($0).map{ SupplementName(name:$0.name) }, forKey: $0)
        }
    }
}
