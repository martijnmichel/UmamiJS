//
//  WebsiteModel.swift
//  UmamiJS
//
//  Created by Martijn van der Eijk on 28/06/2024.
//

import Alamofire
import Foundation

struct WebsitesModel {
    static let token = UmamiClient.getToken()
    static let api = UmamiClient.getWebsite()
    
    
    struct GetWebsitesResponse: Codable {
        var data: [WebsiteDetailsModel.Website]
    }


    
    static func getWebsites(completion: @escaping ([WebsiteDetailsModel.Website]?, AFError?) -> ()) {
        AF.request("\(api ?? "")/api/websites", headers: ["Authorization": "Bearer \(token ?? "")"]).responseDecodable(of: GetWebsitesResponse.self) { response in
            
            switch response.result {
                case .success(let data):
                    completion(data.data, nil)
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    struct AddWebsiteBody: Codable {
        var name, domain: String
    }

    static func addWebsite(params: AddWebsiteBody, completion: @escaping (WebsiteDetailsModel.Website, AFError?) -> ()) {
        AF.request("\(api ?? "")/api/websites", method: .post, parameters: params, headers: ["Authorization": "Bearer \(token ?? "")"]).responseDecodable(of: WebsiteDetailsModel.Website.self) { response in
            
            switch response.result {
                case .success(let data):
                    completion(data, nil)
                
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    static func removeWebsiteById(websiteId: String, completion: @escaping (Bool) -> ()) {
        AF.request("\(api ?? "")/api/websites/\(websiteId)", method: .delete, headers: ["Authorization": "Bearer \(token ?? "")"]).response { response in
                    
            switch response.response?.statusCode {
                case 200:
                    completion(true)
                case 405:
                    print("Not allowed")
                    completion(false)
                default:
                    print("Something went wrong")
                    completion(false)
            }
        }
    }
}
