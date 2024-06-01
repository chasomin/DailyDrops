//
//  SupplementSettingViewModel.swift
//  DailyDrops
//
//  Created by 차소민 on 3/21/24.
//

import Foundation
import UserNotifications

final class SupplementSettingViewModel {
        
    private let repository = RealmRepository()
    
    let inputSupplementViewDidLoad: Observable<Void?> = Observable(nil)
    let inputSupplementDeleteAction: Observable<MySupplement?> = Observable(nil)
    
    let outputSupplement: Observable<[MySupplement]?> = Observable(nil)
    
    init() { transform() }
    
    private func transform() {
        inputSupplementViewDidLoad.bind { [weak self] value in
            guard let self, let value else { return }
            outputSupplement.value = repository.readSupplement().filter { $0.deleteDate == nil }
        }
        
        inputSupplementDeleteAction.bind { [weak self] value in
            guard let self, let value else { return }
            repository.deleteSupplement(id: value.id) {
                self.outputSupplement.value = self.repository.readSupplement().filter { $0.deleteDate == nil }
            }
            removeLocalNotification(deleteItem: value)
        }
    }
    
    private func removeLocalNotification(deleteItem item: MySupplement) {
        let center = UNUserNotificationCenter.current()
        let days = item.days
        let times = item.times
        for day in days {
            for time in times {
                let id = day.description+time.dateFilterTime()
                center.getPendingNotificationRequests { requests in
                    let request = requests.filter{ $0.identifier == id }
                    
                    request.forEach {
                        let timeComponent = $0.content.title.components(separatedBy: "] ")
                        let timeStr = (timeComponent.first ?? "") + "]"
                        
                        let supplements = timeComponent[1]
                        var supplementList = supplements.components(separatedBy: ", ")
                        
                        /// ID를 요일+시간 으로 저장하기 때문에 "매일 8시" 알림을 지우면 "주말 8시" 알림도 같이 삭제된다
                        /// -> title에 영양제 이름을 구해서 그게 1개 이상이면 "주말 8시" 알림 (2개)을 다시 맞춘다
                        
                        if supplementList.count > 1 {
                            let sameRequest = request.filter{ $0.content.title == "\(timeStr) \(supplementList.joined(separator: ", "))"}
                            let days = sameRequest.map{ String($0.identifier.first!) }

                            center.removePendingNotificationRequests(withIdentifiers: [id])

                            guard let index = supplementList.firstIndex(of: item.name) else { return }
                            supplementList.remove(at: index)

                            var dateComponent = DateComponents()
                            let content = UNMutableNotificationContent()

                            content.title = "\(timeStr) \(supplementList.joined(separator: ", "))"
                            content.body = "오늘도 건강한 하루 보내세요 :)"
                            content.badge = 1
                            content.sound = UNNotificationSound.defaultCritical
                            
                            for day in days {
                                dateComponent.weekday = Int(day)
                                dateComponent.hour = time.dateFilterHour()
                                dateComponent.minute = time.dateFilterMinute()
                                
                                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
                                let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
                                center.add(request)
                            }
                        } else {
                            
                            center.removePendingNotificationRequests(withIdentifiers: [id])
                        }
                        
                    }
                }
            }
        }
    }
}
