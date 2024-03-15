//
//  RealmRepository.swift
//  DailyDrops
//
//  Created by 차소민 on 3/11/24.
//

import Foundation
import RealmSwift

final class RealmRepository<T: Object> {
    private let realm = try! Realm()
    
    // MARK: - Create
    func createItem(_ item: T, completion: (() -> Void)?) {
        do {
            print(realm.configuration.fileURL)
            try realm.write {
                realm.add(item)
                completion?()
            }
        } catch {
            print(error)
        }
    }
    
    // MARK: - Read    
    func readWaterByDate(date: Date) -> Float {
        let result = realm.objects(RealmWater.self).map{ $0.toEntity() }.filter{ $0.date.dateFormat() == date.dateFormat()}
        var total: Float = 0
        result.forEach{
            total += $0.drinkWater
        }
        return total
    }
    
    func readGoalCups() -> Float {
        return realm.objects(RealmGoal.self).sorted(byKeyPath: "regDate").last?.waterCup ?? 0
    }
    
    func readSupplement(_ item: T) -> [MySupplement] {
        realm.objects(RealmSupplement.self).map{ $0.toEntity() }
    }
    
    /// 오늘 복용할 약 배열을 리턴하는 메서드
    func readTodaySupplement() -> [MySupplement] {
        let today = Date()
        let supplements = realm.objects(RealmSupplement.self)
        let filterContainToday = supplements.where{$0.days.contains(today.dateFilterDay())}
        return filterContainToday.map{ $0.toEntity() }
    }
    
    /// 해당 시간 대에 복용할 약 배열을 리턴하는 메서드
    func readSupplementForTime(_ time: String) -> [MySupplement] {
        let today = Date()
        let supplements = realm.objects(RealmSupplement.self)
        let filterContainToday = supplements.where{$0.days.contains(today.dateFilterDay())}.map{ $0.toEntity() }
        return filterContainToday.filter{ $0.times.map{ $0.dateFilterTime() }.contains(time) }
    }

    /// 오늘 복용할 약의 시간대를 리턴하는 메서드
    func readTodaySupplementTime() -> [String] {
        let todaySupplement = readTodaySupplement()
        
        var times: [String] = []
        todaySupplement.forEach {
            $0.times.forEach {
                times.append($0.dateFilterTime())
            }
        }
        return Set(times).sorted()
    }
}
