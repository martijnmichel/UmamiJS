//
//  PageviewsModel.swift
//  UmamiJS
//
//  Created by Martijn van der Eijk on 28/06/2024.
//

import Alamofire
import Foundation

struct PageviewsModel {
    static let token = UmamiClient.getToken()
    static let api = UmamiClient.getWebsite()
    
    enum UnitType: Codable {
        case hour, month, year, day
    }
    
    struct GetPageviewsBody: Codable {
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
    
    struct GetPageviewsResponse: Codable {
        let pageviews: [Pageview]
        let sessions: [Pageview]
    }

    struct Pageview: Codable, Identifiable {
        let id = UUID()
        let x: Date
        let y: Int
    }

    
    static func getPageviews(websiteId: String, params: GetPageviewsBody, completion: @escaping (GetPageviewsResponse, AFError?) -> ()) {
        let formatter = DateFormatter()

        var decoder: JSONDecoder {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .custom { decoder in
                let container = try decoder.singleValueContainer()
                let dateString = try container.decode(String.self)

                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                if let date = formatter.date(from: dateString) {
                    return date
                }
                formatter.dateFormat = "yyyy-MM-dd"
                if let date = formatter.date(from: dateString) {
                    return date
                }
                throw DecodingError.dataCorruptedError(in: container,
                                                       debugDescription: "Cannot decode date string \(dateString)")
            }
            return decoder
        }
        
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        AF.request("\(api ?? "")/api/websites/\(websiteId)/pageviews", parameters: params.parameters, headers: ["Authorization": "Bearer \(token ?? "")"]).responseDecodable(of: GetPageviewsResponse.self, decoder: decoder) { response in
            
            switch response.result {
                case .success(let data):
                    completion(data, nil)
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
}
