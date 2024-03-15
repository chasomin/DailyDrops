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
    @Persisted var waterCup: Float
    @Persisted var steps: Int
    @Persisted var regDate: Date
    
    convenience init(waterCup: Float, steps: Int) {
        self.init()
        self.waterCup = waterCup
        self.steps = steps
        self.regDate = Date()
    }
    
    func toEntity() -> Goal {
        return Goal(id: id.stringValue, waterCup: waterCup, steps: steps, regDate: regDate)
    }
}
