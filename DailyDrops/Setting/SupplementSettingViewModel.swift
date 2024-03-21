//
//  SupplementSettingViewModel.swift
//  DailyDrops
//
//  Created by 차소민 on 3/21/24.
//

import Foundation

final class SupplementSettingViewModel {
        
    private let repository = RealmRepository()
    
    let inputSupplementViewDidLoad: Observable<Void?> = Observable(nil)
    let inputSupplementDeleteAction: Observable<MySupplement?> = Observable(nil)
    
    let outputSupplement: Observable<[MySupplement]?> = Observable(nil)
    
    init() { transform() }
    
    private func transform() {
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
}
