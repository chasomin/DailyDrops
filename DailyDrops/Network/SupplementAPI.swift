//
//  SupplementAPI.swift
//  DailyDrops
//
//  Created by 차소민 on 3/7/24.
//

import Foundation

enum SupplementAPI {
    
    case all
    case search(searchText: String)
    
    static let start: String = "1"
    static let end: String = "15"

    
    var endPoint: String {
        let searchParam: String = ""
        
        switch self {
        case .all:
            return "http://openapi.foodsafetykorea.go.kr/api/35fb7bd585e24efa9699/I0030/json/\(SupplementAPI.start)/\(SupplementAPI.end)"
        case .search(let searchText):
            return "http://openapi.foodsafetykorea.go.kr/api/35fb7bd585e24efa9699/I0030/json/\(SupplementAPI.start)/\(SupplementAPI.end)/PRDLST_NM=\(searchText)"
        }
    }
}
