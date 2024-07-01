//
//  WebsiteDetailModel.swift
//  UmamiJS
//
//  Created by Martijn van der Eijk on 25/06/2024.
//

import Foundation
import Alamofire
import SwiftUI

@MainActor
class WebsiteDetailViewModel: NSObject, ObservableObject {
    
    
    @Published var websiteId: String
    
    let token = UmamiClient.getToken()
    
    @Published var website: WebsiteDetailsModel.Website?
    @Published var active: Int?
    
    init(websideId: String) {
        self.websiteId = websideId
    }
    
    func getWebsite() {
        WebsiteDetailsModel.getWebsiteDetails(websiteId: websiteId) { result, _ in self.website = result }
    }
    
   
    
}



extension Date {
    func toMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}

