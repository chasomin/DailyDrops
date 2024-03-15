//
//  MySupplement.swift
//  DailyDrops
//
//  Created by 차소민 on 3/16/24.
//

import Foundation
import RealmSwift

struct MySupplement {

    let name: String
    let days: [Int]
    let times: [Date]
    
    func toDTO() -> RealmSupplement {
        var dayList = List<Int>()
        var timeList = List<Date>()
        dayList.append(objectsIn: days)
        timeList.append(objectsIn: times)
        return RealmSupplement(name: name, days: dayList, times: timeList)
    }
}
