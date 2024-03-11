//
//  RealmWater.swift
//  DailyDrops
//
//  Created by 차소민 on 3/11/24.
//

import Foundation
import RealmSwift

final class RealmWater: Object {
    let repository = RealmRepository()
    
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var date: Date
    @Persisted var drinkWater: Int
    @Persisted var goal: ObjectId
    
    convenience init(drinkWater: Int, goal: ObjectId) {
        self.init()
        self.date = Date()
        self.drinkWater = drinkWater
        self.goal = goal
    }
    
    func toEntity() -> Water {
        return Water(id: id.stringValue, date: date, drinkWater: drinkWater, goal: repository.readGoalCups(id: goal))
    }
}

struct Water {
    let id: String
    let date: Date
    let drinkWater: Int
    let goal: Int
}
