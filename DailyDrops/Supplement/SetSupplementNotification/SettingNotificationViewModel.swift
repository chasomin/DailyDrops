//
//  SettingNotificationViewModel.swift
//  DailyDrops
//
//  Created by 차소민 on 3/12/24.
//

import Foundation
import UserNotifications
import UIKit

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
        var time: [Date] = value.times[...outputSegmentTapped.value].map { $0 }.sorted()
        let timeStr = Set(time.map { $0.dateFilterTime() })
        let resultTime = timeStr.map{ $0.formatDate() }
        repository.createItem(MySupplement(id: value.id, regDate: Date(), name: value.name, days: value.days.sorted(), times: resultTime.sorted(), deleteDate: nil).toDTO(), completion: nil)
        outputSaveButtonTapped.value = ()
        setNotification(value)
    }
    
    func setNotification(_ value: MySupplement) {
        let name = value.name
        let days = value.days
        let times = value.times[...outputSegmentTapped.value].map { $0 }.sorted()
        
        let content = UNMutableNotificationContent()
        var component = DateComponents()
        let center = UNUserNotificationCenter.current()
        content.body = "오늘도 건강한 하루 보내세요 :)"
        content.badge = 1
        content.sound = UNNotificationSound.defaultCritical

        // FIXME: 반복문+반복문+조건문+반복문 이게 최선인가........ 그리고 id 64개 넘으면 어떡하징
        
        for day in days {
            for time in times {
                
                let id = day.description+time.dateFilterTime()
                center.getPendingNotificationRequests { requests in
                    if requests.isEmpty {
                        content.title = "[\(time.dateFilterTime())] \(name)"
                    } else {
                        let request = requests.filter { $0.identifier == id }
                        if request.isEmpty {
                            content.title = "[\(time.dateFilterTime())] \(name)"
                        } else {
                            request.forEach { content.title = "\($0.content.title), \(name)" }
                        }
                    }
                    component.weekday = day
                    component.hour = time.dateFilterHour()
                    component.minute = time.dateFilterMinute()
                                        
                    let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: true)
                    let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
                    center.add(request)

                }
            }
        }
    }
}
