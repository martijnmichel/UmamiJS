//
//  MetricsModel.swift
//  UmamiJS
//
//  Created by Martijn van der Eijk on 28/06/2024.
//

import Alamofire
import Foundation

enum MetricsModel {
    static let token = UmamiClient.getToken()
    static let api = UmamiClient.getWebsite()
    
    enum MetricType: Codable {
        case url, referrer, browser, os, device, country, event
    }
    
    struct GetMetricsBody: Codable, Hashable {
        var startAt, endAt: Int64
        var type: MetricType
        var limit: Int?
        var referrer, url: String?
        
        var parameters: Parameters {
            var p: [String: Any] = [
                "startAt": startAt,
                "endAt": endAt,
                "type": type,
                "timezone": TimeZone.current.identifier,
            ]
            if limit != nil { p["limit"] = limit }
            if referrer != nil { p["referrer"] = referrer }
            if url != nil { p["url"] = url }
            return p
        }
    }
    
    struct Metric: Codable, Identifiable {
        let id = UUID()
        var x: String
        var y: Int
    }
    
    typealias GetMetricsResponse = [Metric]
    
    static func getMetrics(websiteId: String, params: GetMetricsBody, completion: @escaping (GetMetricsResponse, AFError?) -> ()) {
        AF.request("\(api ?? "")/api/websites/\(websiteId)/metrics", parameters: params.parameters, headers: ["Authorization": "Bearer \(token ?? "")"]).responseDecodable(of: [Metric].self) { response in
            
            switch response.result {
            case .success(let data):
                completion(data, nil)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
