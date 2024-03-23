//
//  PermissionViewModel.swift
//  DailyDrops
//
//  Created by 차소민 on 3/24/24.
//

import Foundation

final class PermissionViewModel {
    let inputViewDidLoad: Observable<Void?> = Observable(nil)
    let inputSwitchTapped: Observable<Void?> = Observable(nil)
    
    let outputNotification: Observable<Void?> = Observable(nil)
    let outputSwitchValue: Observable<Bool?> = Observable(nil)
    
    init() { transform() }
    
    private func transform() {
        inputViewDidLoad.bind { value in
            guard let value else { return }
            NotificationManager.shared.checkNotificationAuthorization { [weak self] value in
                guard let self else { return }
                outputSwitchValue.value = value
            }
        }
        
        inputSwitchTapped.bind { [weak self] value in
            guard let self, let value else { return }
            outputNotification.value = ()
            
            NotificationManager.shared.checkNotificationAuthorization { [weak self] value in
                guard let self else { return }
                outputSwitchValue.value = value
            }
            
        }
    }
}
