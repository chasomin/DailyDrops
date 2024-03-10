//
//  SupplementDTO.swift
//  DailyDrops
//
//  Created by 차소민 on 3/8/24.
//

import Foundation

struct ServiceDTO: Decodable {
    let I0030: InfoDTO
    
    func toEntity() -> Service {
        Service(serviceID: I0030.toEntity())
    }
}

struct InfoDTO: Decodable {
    let totalCount: String
    let dataList: [SupplementDTO]?
    let result: ResultDTO
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case dataList = "row"
        case result = "RESULT"
    }
    
    func toEntity() -> Info {
        return Info(totalCount: totalCount, dataList: dataList?.map{$0.toEntity()} ?? [], result: result.toEntity())
    }
}

struct SupplementDTO: Decodable {
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
    
    func toEntity() -> Supplement {
        return Supplement(supplementName: supplementName, shape: shape, corporateName: corporateName, intakeMethod: intakeMethod)
    }
}

struct ResultDTO: Decodable {
    let message: String
    let code: String
    
    enum CodingKeys: String, CodingKey {
        case message = "MSG"
        case code = "CODE"
    }
    func toEntity() -> Result {
        return Result(message: message, code: code)
    }
}

