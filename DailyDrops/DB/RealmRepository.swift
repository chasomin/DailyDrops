//
//  RealmRepository.swift
//  DailyDrops
//
//  Created by 차소민 on 3/11/24.
//

import Foundation
import RealmSwift

final class RealmRepository<T: Object> {
    let realm = try! Realm()
    
    // MARK: Create
    func createItem(_ item: T) {
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print(error)
        }
    }
    
    // MARK: Read
    func readWaterLog() -> [Water] {
        let result = realm.objects(RealmWater.self)
        return result.map{ $0.toEntity() }
    }
    
    func readWaterByDate(date: Date) -> [Water] {
        let result = realm.objects(RealmWater.self)
        return result.map{ $0.toEntity() }.filter{ $0.date == date} //TODO: date 년월일만 format해서 비교
    }
    
    func readGoalCups(id: ObjectId) -> Int {
        return realm.objects(RealmGoal.self).filter{ $0.id == id }.first?.waterCup ?? 0
    }

}
 
