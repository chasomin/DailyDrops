//
//  Supplement.swift
//  DailyDrops
//
//  Created by 차소민 on 3/8/24.
//

import Foundation

struct Info {
    let totalCount: String
    let dataList: [SupplementDTO]      // data 없으면 오류처리
    let result: ResultDTO
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case dataList = "row"
        case result = "RESULT"
    }
}

struct Supplement {
    let supplementName: String           // 영양제 이름
    let shape: String                    // 영양제 형태 (ex.캡슐 / 정)
    let corporateName: String            // 회사명
    let intakeMethod: String             // 섭취 방법
    
    enum CodingKeys: String, CodingKey {
        case supplementName = "PRDLST_NM"
        case shape = "PRDT_SHAP_CD_NM"
        case corporateName = "BSSH_NM"
        case intakeMethod = "NTK_MTHD"
    }
}

struct Result {
    let message: String
    let code: String
    
    enum CodingKeys: String, CodingKey {
        case message = "MSG"
        case code = "CODE"
    }
}
