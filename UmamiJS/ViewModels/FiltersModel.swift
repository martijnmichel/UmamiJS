//
//  FiltersModel.swift
//  UmamiJS
//
//  Created by Martijn van der Eijk on 29/06/2024.
//

import Foundation

@MainActor
class FiltersModel: ObservableObject {
    @Published var filters: Filters

    struct Filters: Equatable {
        var startAt, endAt: Date
        var referrer, url: String?
    }
    
    init() {
        self.filters = Filters(startAt: Calendar.current.date(byAdding: .month, value: -1, to: Date())!, endAt: Date())
    }
    
    func clear() {
        self.filters = Filters(startAt: Calendar.current.date(byAdding: .month, value: -1, to: Date())!, endAt: Date())
    }
    func setFilters(models: [(PageviewsViewModel, StatsViewModel)]) {
        models.forEach { $0.filters = $1.filters }
        
    }
}
