//
//  StatsModel.swift
//  UmamiJS
//
//  Created by Martijn van der Eijk on 28/06/2024.
//

import Alamofire
import Foundation

enum StatsModel {
    static let token = UmamiClient.getToken()
    static let api = UmamiClient.getWebsite()
    
    enum UnitType: Codable {
        case hour, month, year, day
    }
    
    struct GetStatsBody: Codable {
        var startAt, endAt: Int64
        var unit: UnitType
        var referrer, url: String?
        
        var parameters: Parameters {
            var p: [String: Any] = [
                "startAt": startAt,
                "endAt": endAt,
                "unit": unit,
                "timezone": TimeZone.current.identifier
            ]
            if referrer != nil { p["referrer"] = referrer }
            if url != nil { p["url"] = url }
            return p
        }
    }
    
    struct GetStatsResponse: Codable {
        let pageviews, visitors, visits, bounces, totaltime: WebsiteStat
    }

    struct WebsiteStat: Codable {
        let value, prev: Int
    }
    
    static func getWebsiteStats(websiteId: String, params: GetStatsBody, completion: @escaping (GetStatsResponse, AFError?) -> ()) {
        AF.request("\(api ?? "")/api/websites/\(websiteId)/stats", parameters: params.parameters, headers: ["Authorization": "Bearer \(token ?? "")"]).responseDecodable(of: GetStatsResponse.self) { response in
            
            switch response.result {
                case .success(let data):
                    completion(data, nil)
                    
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
}
