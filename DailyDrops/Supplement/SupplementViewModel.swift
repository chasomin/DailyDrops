//
//  SupplementViewModel.swift
//  DailyDrops
//
//  Created by 차소민 on 3/10/24.
//

import Foundation

final class SupplementViewModel {
    
    let inputViewDidLoad: Observable<Void?> = Observable(nil)
    let outputData: Observable<[Supplement]> = Observable([])
    let outputSetTableView: Observable<Void?> = Observable(nil)
    let outputSetNavigation: Observable<Void?> = Observable(nil)
    
    init () { transform() }
    
    private func transform() {
        inputViewDidLoad.bind { [weak self] value in
            guard let value, let self else { return }
            fetch()
            outputSetTableView.value = ()
            outputSetNavigation.value = ()
        }
    }
    
    private func fetch() {
        APIManager.shared.callRequest(api: .all) { [weak self] result, error in
            guard let error else {
                guard let result, let self else { return }
                outputData.value = result
                return
            }
            print(error)//TODO: Error
        }
    }
}
