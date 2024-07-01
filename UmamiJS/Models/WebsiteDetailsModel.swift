//
//  WebsiteDetailsModel.swift
//  UmamiJS
//
//  Created by Martijn van der Eijk on 28/06/2024.
//

import Foundation
import Alamofire



struct WebsiteDetailsModel {
    static let token = UmamiClient.getToken()
    static let api = UmamiClient.getWebsite()
    
   

    struct Website: Codable, Identifiable, Hashable {
        let id, name, domain, userId: String
    }

    
    static func getWebsiteDetails(websiteId: String, completion: @escaping (Website, AFError?) -> ()) {
        AF.request("\(api ?? "")/api/websites/\(websiteId)", headers: ["Authorization": "Bearer \(token ?? "")"]).responseDecodable(of: Website.self) { response in
            
            switch response.result {
                case .success(let data):
                    completion(data, nil)
                case .failure(let error):
                    print(error.localizedDescription)
            }
            
        }
    }
    
    
    

    struct WebsiteActiveResponse: Codable {
        let x: Int
    }
    
    static func getWebsiteActiveUsers(websiteId: String, completion: @escaping (Int, AFError?) -> ()) {
        
        
        AF.request("\(api ?? "")/api/websites/\(websiteId)/active", headers: ["Authorization": "Bearer \(token ?? "")"]).responseDecodable(of: WebsiteActiveResponse.self) { response in
            
            switch response.result {
                case .success(let data):
                completion(data.x, nil)
                case .failure(let error):
                    print(error.localizedDescription)
            }
            
        }
    }
    
    

    
}
