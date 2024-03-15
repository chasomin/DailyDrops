//
//  RealmSupplement.swift
//  DailyDrops
//
//  Created by 차소민 on 3/13/24.
//

import Foundation
import RealmSwift

final class RealmSupplement: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var days: List<Int>
    @Persisted var times: List<Date>

    convenience init(name: String, days: List<Int>, times: List<Date>) {
        self.init()
        
        self.name = name
        self.days = days
        self.times = times
    }
    
    func toEntity() -> MySupplement {
        return MySupplement(name: name, days: days.map{$0}, times: times.map{$0})
    }
}
