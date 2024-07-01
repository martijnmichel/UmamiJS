//
//  WebsitesViewModel.swift
//  UmamiJS
//
//  Created by Martijn van der Eijk on 25/06/2024.
//

import Alamofire
import Foundation
import SwiftUI

class WebsitesViewModel: ObservableObject {
    let token = UmamiClient.getToken()
    @Published var websites: [WebsiteDetailsModel.Website]?
    
    init() {
        load()
    }

    func load() {
        WebsitesModel.getWebsites { result, _ in self.websites = result }
    }
    
    func addWebsite(params: WebsitesModel.AddWebsiteBody) {
        WebsitesModel.addWebsite(params: params) { result, _ in self.websites?.append(result) }
    }
    
    func removeWebsite(at offsets: IndexSet) {
        if let websites = websites {
            for index in offsets {
                let item = websites[index]
                WebsitesModel.removeWebsiteById(websiteId: item.id) { (result) in
                    if (result == true) {
                        self.websites?.remove(atOffsets: offsets)
                    }
                }
            }
        }
    }
}
