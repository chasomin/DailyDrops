//
//  RealmSupplement.swift
//  DailyDrops
//
//  Created by 차소민 on 3/13/24.
//

import Foundation
import RealmSwift

final class RealmSupplement: Object {
    @Persisted(primaryKey: true) var id: UUID   // PK
    @Persisted var regDate: Date                // 영양제 등록일
    @Persisted var name: String                 // 영양제 이름
    @Persisted var days: List<Int>              // 영양제 복용 요일
    @Persisted var times: List<Date>            // 영양제 복용 시간
    @Persisted var deleteDate: Date?            // 영양제 삭제일

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
