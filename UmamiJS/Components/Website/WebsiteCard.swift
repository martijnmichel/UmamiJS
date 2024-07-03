//
//  WebsiteCard.swift
//  UmamiJS
//
//  Created by Martijn van der Eijk on 25/06/2024.
//

import SwiftUI

struct WebsiteCard: View {
    
    var websiteId: String
    
    @ObservedObject private var filters: FiltersModel
    @ObservedObject private var model: WebsiteDetailViewModel
    @ObservedObject private var statsModel: StatsViewModel
    
    init(websiteId: String, filters: FiltersModel) {
        self.websiteId = websiteId
        self.filters = filters
        self.model = WebsiteDetailViewModel(websideId: websiteId)
        self.statsModel = StatsViewModel(websideId: websiteId, manager: filters)
      
        self.statsModel.getStats()
        self.model.getWebsite()
        print(self.filters)
    }
    
    
    
    var body: some View {
        
        
        if let website = model.website {
            
                VStack {
                    
                    VStack(alignment: .leading) {
                        HStack {
                            
                            Text(website.name).cardTitle()
                        }
                        Text(model.website?.domain ?? "").font(.caption).foregroundStyle(.gray)
                        
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))]) {
                            if statsModel.data != nil {
                                WebsiteStats(model: statsModel)
                            }
                            
                            
                          
                        }
                        
                        
                        
                    }.cardContent()
                }.card()
            
        }
    }
}


struct WebsiteCard_Previews: PreviewProvider {
    @ObservedObject static var filters = FiltersModel()
    static var previews: some View {
        NavigationStack {
            WebsiteCard(websiteId: "31de6a02-3b36-44c8-9d1c-ddbda7f8ea1e", filters: filters)
        }
    }
}

