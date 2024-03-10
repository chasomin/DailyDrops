//
//  APIManager.swift
//  DailyDrops
//
//  Created by 차소민 on 3/8/24.
//

import Foundation
import Alamofire

final class APIManager {
    static let shared = APIManager()
    private init() { }
    
    //TODO: ERROR 핸들링, Toast
    func callRequest(api: SupplementAPI, completionHandler: @escaping ([Supplement]?, Error?) -> Void) {
        AF.request(api.endPoint).responseDecodable(of: ServiceDTO.self) { response in
            switch response.result {
            case .success(let success):
                completionHandler(success.toEntity().serviceID.dataList, nil)
                print(success)
            case .failure(let failure):
                completionHandler(nil, failure)
            }
        }
    }
}
