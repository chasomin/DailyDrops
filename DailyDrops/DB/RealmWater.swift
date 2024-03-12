//
//  RealmWater.swift
//  DailyDrops
//
//  Created by 차소민 on 3/11/24.
//

import Foundation
import RealmSwift

final class RealmWater: Object {
    
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var date: Date
    @Persisted var drinkWater: Float
    
    convenience init(drinkWater: Float) {
        self.init()
        self.date = Date()
        self.drinkWater = drinkWater
    }
    
    func toEntity() -> Water {
        return Water(id: id.stringValue, date: date, drinkWater: drinkWater)
    }
}

struct Water {
    let id: String
    let date: Date
    let drinkWater: Float
}
