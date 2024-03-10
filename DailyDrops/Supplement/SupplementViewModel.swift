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
    
    init () {
        inputViewDidLoad.bind { [weak self] value in
            guard let value, let self else { return }
            fetch()
        }
    }
    
    private func fetch() {
        APIManager.shared.callRequest(api: .all) { [weak self] result, error in
            guard let error else {
                guard let result, let self else { return }
                outputData.value = result
                return
            }
            print(error)
        }
    }
}
