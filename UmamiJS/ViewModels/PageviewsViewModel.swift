//
//  PageviewsViewModel.swift
//  UmamiJS
//
//  Created by Martijn van der Eijk on 28/06/2024.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class PageviewsViewModel: ObservableObject {
    @Published var websiteId: String
    
    @Published var filters: FiltersModel = FiltersModel()
    
    @Published var body: PageviewsModel.GetPageviewsBody = .init(startAt: Date().toMillis() - 86400000, endAt: Date().toMillis(), unit: .day)
    @Published var data: PageviewsModel.GetPageviewsResponse?
    private var cancellables: [AnyCancellable] = []
    
    var barmarkColumns: CGFloat {
        switch body.unit {
            case .day: 
                let diffs = Calendar.current.dateComponents([.day], from: filters.filters.startAt, to: filters.filters.endAt)
                return CGFloat(diffs.day ?? 0)
            case .hour: 
                let diffs = Calendar.current.dateComponents([.hour], from: filters.filters.startAt, to: filters.filters.endAt)
                return CGFloat(diffs.hour ?? 0)
            case .month:
                let diffs = Calendar.current.dateComponents([.month], from: filters.filters.startAt, to: filters.filters.endAt)
                return CGFloat(diffs.month ?? 0)
            case .year: 
                let diffs = Calendar.current.dateComponents([.year], from: filters.filters.startAt, to: filters.filters.endAt)
                return CGFloat(diffs.year ?? 0)
                
        }
    }
    
    
    struct PageViewMetric: Identifiable {
        let id = UUID()
        let x: Date
        let y: Int
        let z: String
    }
    
    var stacked: [PageViewMetric] {
        var pageviews = data?.pageviews.enumerated().map { PageViewMetric(x: $1.x, y: $1.y, z: "Pageview") }

        let sessions = data?.pageviews.enumerated().map { PageViewMetric(x: $1.x, y: $1.y, z: "Session") }

        pageviews?.insert(contentsOf: sessions ?? [], at: 0)
        
        return pageviews ?? []
    }
    
    let token = UmamiClient.getToken()
    
    init(websiteId: String, manager: FiltersModel? = nil) {
        self.websiteId = websiteId
        
        if let manager = manager {
            self.filters = manager
            body.startAt = manager.filters.startAt.toMillis()
        }
        
        self.filters.$filters.dropFirst().removeDuplicates().sink {
            value in
            print("Received filters update")
            self.body.startAt = value.startAt.toMillis()
            self.body.endAt = value.endAt.toMillis()
            self.body.referrer = value.referrer
            self.body.url = value.url
            self.getPageviews()
        }.store(in: &self.cancellables)
        
        
        
    }
    
    deinit {
            self.cancellables.removeAll()
        }
    
    func getPageviews() {
        PageviewsModel.getPageviews(websiteId: websiteId, params: body) {
            result, _ in
            self.data = result
        }
    }
    
    
}
