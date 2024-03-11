//
//  Goal.swift
//  DailyDrops
//
//  Created by 차소민 on 3/11/24.
//

import Foundation
import RealmSwift

final class RealmGoal: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var waterCup: Int
    @Persisted var steps: Int
    
    convenience init(waterCup: Int, steps: Int) {
        self.init()
        self.waterCup = waterCup
        self.steps = steps
    }
    
    func toEntity() -> Goal {
        return Goal(id: id.stringValue, waterCup: waterCup, steps: steps)
    }
}

struct Goal {
    let id: String
    let waterCup: Int
    let steps: Int
}
