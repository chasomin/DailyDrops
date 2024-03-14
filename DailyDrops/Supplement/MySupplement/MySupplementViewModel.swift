//
//  MySupplementViewModel.swift
//  DailyDrops
//
//  Created by 차소민 on 3/14/24.
//

import Foundation

final class MySupplementViewModel {
    let repository = RealmRepository()
    
    let inputViewModel: Observable<Void?> = Observable(nil)
    
    let outputSetNavigation: Observable<Void?> = Observable(nil)
    
    init() {
        transform()
    }
    
    private func transform() {
        inputViewModel.bind { [weak self] _ in
            guard let self else { return }
            outputSetNavigation.value = ()
        }
    }
    
    
}
