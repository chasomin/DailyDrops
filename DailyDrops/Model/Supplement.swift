//
//  Supplement.swift
//  DailyDrops
//
//  Created by 차소민 on 3/8/24.
//

import Foundation

struct Info {
    let totalCount: String
    let dataList: [Supplement]      // data 없으면 오류처리
    let result: Result
}

struct Supplement {
    let supplementName: String           // 영양제 이름
    let shape: String                    // 영양제 형태 (ex.캡슐 / 정)
    let corporateName: String            // 회사명
    let intakeMethod: String             // 섭취 방법
}

struct Result {
    let message: String
    let code: String
}
