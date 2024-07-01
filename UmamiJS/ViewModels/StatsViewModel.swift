//
//  StatsViewModel.swift
//  UmamiJS
//
//  Created by Martijn van der Eijk on 28/06/2024.
//


import Combine
import Foundation
@MainActor
class StatsViewModel: ObservableObject {
    
    @Published var filters: FiltersModel = FiltersModel()
    private var cancellables: [AnyCancellable] = []
    
    
    @Published var websiteId: String
    @Published var body: StatsModel.GetStatsBody = StatsModel.GetStatsBody(startAt: (Date().toMillis() - 86400000), endAt: Date().toMillis(), unit: .hour)
    @Published var data: StatsModel.GetStatsResponse?
    
    
    let token = UmamiClient.getToken()
    
    init(websideId: String, manager: FiltersModel? = nil) {
        self.websiteId = websideId
        
        if let manager = manager {
            self.filters = manager
            self.setBodyFromFilters(filters: manager.filters)
        }
        
        self.filters.$filters.dropFirst().removeDuplicates().sink {
            value in
            print("Received filters update")
            self.setBodyFromFilters(filters: value)
            self.getStats()
        }.store(in: &self.cancellables)
        
        
        
    }
    
    func setBodyFromFilters(filters: FiltersModel.Filters) {
        self.body.startAt = filters.startAt.toMillis()
        self.body.endAt = filters.endAt.toMillis()
        self.body.referrer = filters.referrer
        self.body.url = filters.url
    }
    
    func getStats() {
        StatsModel.getWebsiteStats(websiteId: websiteId, params: body) {
            (result, _) in
            self.data = result
        }
    }
}

