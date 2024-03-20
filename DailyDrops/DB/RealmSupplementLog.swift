//
//  RealmSupplementLog.swift
//  DailyDrops
//
//  Created by 차소민 on 3/13/24.
//

import Foundation
import RealmSwift

final class RealmSupplementLog: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var regDate: Date
    @Persisted var supplementName: String
    @Persisted var supplementTime: String   // 영양제 하나가 하루에 3번까지 알림 가능해서 영양제 이름+시간으로 특정 영양제 섭취 유무 확인 가능

    convenience init(supplementName: String, supplementTime: String) {
        self.init()
        self.regDate = Date()
        self.supplementName = supplementName
        self.supplementTime = supplementTime
    }
}

