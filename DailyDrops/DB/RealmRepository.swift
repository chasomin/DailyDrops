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
    func readSupplementLog() -> Results<RealmSupplementLog> {
        return realm.objects(RealmSupplementLog.self)
    }
    
    func readWaterByDate(date: Date) -> Float {
        let result = realm.objects(RealmWater.self).map{ $0.toEntity() }.filter{ $0.date.dateFormat() == date.dateFormat()}
        var total: Float = 0
        result.forEach{
            total += $0.drinkWater
        }
        return total
    }
    
    func readFirstGoal() -> Goal {
        let goal = realm.objects(RealmGoal.self).map { $0.toEntity() }
        guard let firstGoal = goal.sorted(by: {$0.regDate < $1.regDate}).first else { return Goal(id: "", waterCup: 0, steps: 0, regDate: Date())}
        return firstGoal
    }
    
    func readGoalCups(date: Date) -> Float {
        let goal = realm.objects(RealmGoal.self).map { $0.toEntity() }
        return goal.filter{$0.regDate.dateWithMidnight() <= date}.sorted(by: {$0.regDate < $1.regDate}).last?.waterCup ?? 0
    }
    
    func readGoalSteps(date: Date) -> Int {
        let goal = realm.objects(RealmGoal.self).map { $0.toEntity() }
        return goal.filter { $0.regDate.dateWithMidnight() <= date }.sorted(by: {$0.regDate < $1.regDate}).last?.steps ?? 0
    }
    
    func readSupplement() -> Results<RealmSupplement> {
        realm.objects(RealmSupplement.self)
            //.where({$0.regDate <= date})
    }
    
    func readSupplement() -> [MySupplement] {
        realm.objects(RealmSupplement.self).map{ $0.toEntity() }
    }
    
    /// 특정 날짜에 복용할 약 배열을 리턴하는 메서드
    func readSupplementByDate(date: Date) -> [MySupplement] {
        let supplements = realm.objects(RealmSupplement.self)
        let filterContainToday = supplements.where{$0.days.contains(date.dateFilterDay())}
        return filterContainToday.map{ $0.toEntity() }.filter{ $0.regDate.dateWithMidnight() <= date }
    }
    
    /// 해당 시간 대에 복용할 약 배열을 리턴하는 메서드
    func readSupplementForTime(_ time: String, date: Date) -> [MySupplement] {
//        let today = Date()
        let supplements = realm.objects(RealmSupplement.self)
        let filterContainToday = supplements.where{$0.days.contains(date.dateFilterDay())}.map{ $0.toEntity() }
        return filterContainToday.filter{ $0.times.map{ $0.dateFilterTime() }.contains(time) }
    }

    /// 오늘 복용할 약의 시간대를 리턴하는 메서드
    func readTodaySupplementTime() -> [String] {
        let todaySupplement = readSupplementByDate(date: Date())
        
        var times: [String] = []
        todaySupplement.forEach {
            $0.times.forEach {
                times.append($0.dateFilterTime())
            }
        }
        return Set(times).sorted()
    }
    
    /// 특정 날짜에 복용할 약의 시간대를 리턴하는 메서드
    func readSupplementTimeForDate(_ date: Date) -> [String] {
        let todaySupplement = readSupplementByDate(date: date)
        
        var times: [String] = []
        todaySupplement.forEach {
            $0.times.forEach {
                times.append($0.dateFilterTime())
            }
        }
        return Set(times).sorted()
    }

        
    // MARK: Delete
    func deleteSupplementLog(date: String, name: String, time: String) {
        do {
            try realm.write {
                let result = readSupplementLog().filter({$0.supplementName == name && $0.supplementTime == time && $0.regDate.dateFormat() == date})
                realm.delete(result)
            }
        } catch {
            print(error)
        }
    }    
    
    func deleteSupplement(id: UUID, completion: @escaping () -> Void) {
        do {
            try realm.write {
                let supplements: Results<RealmSupplement> = readSupplement()
                let result = supplements.where({$0.id == id})
                realm.delete(result)
                completion()
            }
        } catch {
            print(error)
        }
    }
}
