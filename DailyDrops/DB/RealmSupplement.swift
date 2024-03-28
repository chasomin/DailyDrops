//
//  RealmSupplement.swift
//  DailyDrops
//
//  Created by 차소민 on 3/13/24.
//

import Foundation
import RealmSwift

final class RealmSupplement: Object {
    @Persisted(primaryKey: true) var id: UUID
    @Persisted var regDate: Date
    @Persisted var name: String
    @Persisted var days: List<Int>
    @Persisted var times: List<Date>
    @Persisted var deleteDate: Date?

    convenience init(name: String, days: List<Int>, times: List<Date>) {
        self.init()
        
        self.regDate = Date()
        self.name = name
        self.days = days
        self.times = times
        self.deleteDate = nil
    }
    
    func toEntity() -> MySupplement {
        return MySupplement(id: id, regDate: regDate, name: name, days: days.map{$0}, times: times.map{$0}, deleteDate: deleteDate)
    }
}
