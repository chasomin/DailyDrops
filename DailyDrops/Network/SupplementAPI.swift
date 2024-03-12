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
    
    static var start: Int = 1
    static var end: Int = 15

    
    var endPoint: String {
        switch self {
        case .all:
            return "https://openapi.foodsafetykorea.go.kr/api/35fb7bd585e24efa9699/I0030/json/\(SupplementAPI.start)/\(SupplementAPI.end)"
        case .search(let searchText):
            return "https://openapi.foodsafetykorea.go.kr/api/35fb7bd585e24efa9699/I0030/json/\(SupplementAPI.start)/\(SupplementAPI.end)/PRDLST_NM=\(searchText)"
        }
    }
}

