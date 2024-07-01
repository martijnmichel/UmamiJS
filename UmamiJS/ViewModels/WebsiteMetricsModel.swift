//
//  WebsiteMetricsModel.swift
//  UmamiJS
//
//  Created by Martijn van der Eijk on 28/06/2024.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class MetricsViewModel: ObservableObject {
    
    
    @Published var websiteId: String
    
    
    @Published var filters: FiltersModel = FiltersModel()
    private var cancellables: [AnyCancellable] = []
    
    @Published var body: MetricsModel.GetMetricsBody = MetricsModel.GetMetricsBody(startAt: (Date().toMillis() - 86400000), endAt: Date().toMillis(), type: .url)
    @Published var data: MetricsModel.GetMetricsResponse?
    
    let token = UmamiClient.getToken()
    
    
    var limitFirst10: MetricsModel.GetMetricsResponse {
        if  let data = self.data {
            return Array(data.prefix(10) )
        } else {
            return []
        }
    }
    
    var total: Int {
        if let data = self.data {
            return data.reduce(0) { $0 + $1.y }
        } else {
            return 0
        }
    }
    
    func rowPerc(value: Int) -> Double {
        
        return Double(value) / Double(total)
    }
    
    func rowPercFormatted(value: Int) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.minimumIntegerDigits = 1
        formatter.maximumIntegerDigits = 2
        formatter.maximumFractionDigits = 2
        
        return formatter.string(for: rowPerc(value: value))
    }
    
    
    init(websideId: String, manager: FiltersModel? = nil) {
        self.websiteId = websideId
        
        if let manager = manager {
            self.filters = manager
            self.setBodyFromFilters(filters: manager.filters)
        }
        
        self.filters.$filters.dropFirst().removeDuplicates().sink {
            value in
            print("Metrics: Received filters update on \(self.body.type)")
            self.setBodyFromFilters(filters: value)
            self.getMetrics()
        }.store(in: &self.cancellables)
        
        
        
    }
    
    deinit {
            self.cancellables.removeAll()
        }
    
    func setBodyFromFilters(filters: FiltersModel.Filters) {
        self.body.startAt = filters.startAt.toMillis()
        self.body.endAt = filters.endAt.toMillis()
        self.body.referrer = filters.referrer
        self.body.url = filters.url
    }
    
    func getMetrics() {
        MetricsModel.getMetrics(websiteId: websiteId, params: body) {
            (result, _) in
            self.data = result
        }
    }
}

enum MetricsLink {
    case pages(String)
    case referrers(String)
}
