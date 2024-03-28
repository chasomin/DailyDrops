//
//  MySupplement.swift
//  DailyDrops
//
//  Created by 차소민 on 3/16/24.
//

import Foundation
import RealmSwift

struct MySupplement {

    let id: UUID
    let regDate: Date
    let name: String
    let days: [Int]
    let times: [Date]
    let deleteDate: Date?
    
    func toDTO() -> RealmSupplement {
        let dayList = List<Int>()
        let timeList = List<Date>()
        dayList.append(objectsIn: days)
        timeList.append(objectsIn: times)
        return RealmSupplement(name: name, days: dayList, times: timeList)
    }
}
