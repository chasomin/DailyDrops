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
    
    // MARK: Read    
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

}
 
