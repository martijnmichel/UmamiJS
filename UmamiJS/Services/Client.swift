//
//  Client.swift
//  UmamiJS
//
//  Created by Martijn van der Eijk on 23/06/2024.
//

import Foundation
import Alamofire

enum UmamiClientError: Error{
    case fetchError
}

typealias Completion<T> = (T, AFError?) -> ()


struct UmamiClient {
    static func getToken() -> String? {
        if let token = UserDefaults.standard.string(forKey: "Token") { return token } else { return nil }
    }
    
    static func getWebsite() -> String? {
        if let token = UserDefaults.standard.string(forKey: "Website") { return token } else { return nil }
    }
    
    static func get<T: Codable>(path: String, query: [URLQueryItem]? = nil) async -> Result<T, UmamiClientError> {
        guard let website = getWebsite() else {
            print("website not set")
            return .failure(.fetchError)
        }
        
        guard let token = getToken() else {
            print("token not set")
            return .failure(.fetchError)
        }
        
        var components = URLComponents(string: "\(website)/api\(path)")!

        components.queryItems = query
        
        guard let url = components.url else {
            print("invalid url")
            return .failure(.fetchError)
        }
        print(url)
        
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        
        
        do {
            let (responseData, _) = try await URLSession.shared.data(for: request)
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            if let data = try? decoder.decode(T.self, from: responseData) {
                print("Decode success")
               
                return .success(data)
            } else {
                print("decoding T failed")
            }
            
        } catch {
            print("Something went wrong")
        }
        
        return .failure(.fetchError)
    }
    
    
    static func post<T: Codable, B: Codable>(path: String, body: B) async -> Result<T, UmamiClientError> {
        guard let website = getWebsite() else {
            print("website not set")
            return .failure(.fetchError)
        }
        
        guard let token = getToken() else {
            print("token not set")
            return .failure(.fetchError)
        }
        
        guard let url = URL(string: "\(website)/api\(path)") else {
            print("invalid url")
            return .failure(.fetchError)
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            
            if let bodyData =  try? JSONEncoder().encode(body) {
                print(body)
                print(bodyData)
                request.httpBody = bodyData
                
                let (responseData, _) = try await URLSession.shared.data(for: request)
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                if let data = try? decoder.decode(T.self, from: responseData) {
                    print("Decode success")
                   
                    return .success(data)
                } else {
                    print("decoding T failed")
                }
            } else {
                
                print("body encoding failed")
            }
            
            
            
        } catch {
            print("Something went wrong")
        }
        
        return .failure(.fetchError)
    }
}
