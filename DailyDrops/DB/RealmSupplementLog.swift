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
    @Persisted var supplementTime: String
    @Persisted var supplementFK: UUID

    convenience init(supplementName: String, supplementTime: String, supplementFK: UUID) {
        self.init()
        self.regDate = Date()
        self.supplementName = supplementName
        self.supplementTime = supplementTime
        self.supplementFK = supplementFK
    }
}

