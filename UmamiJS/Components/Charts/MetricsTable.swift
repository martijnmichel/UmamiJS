//
//  WebsiteMetricsScreen.swift
//  UmamiJS
//
//  Created by Martijn van der Eijk on 28/06/2024.
//

import SwiftUI

struct MetricsTable: View {
    @ObservedObject var model: MetricsViewModel
    
    @Environment(\.horizontalSizeClass) var sizeCategory
    
    @State private var sortOrder = [KeyPathComparator(\MetricsModel.Metric.x)]

    var body: some View {
        if let data = model.data {
            ScrollView(.horizontal) {
                Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 10) {
                    GridRow {
                        Text("Views")
                        Text("View %")
                        Text("Referrers")
                    }.font(.headline)
                    
                    ForEach(data) { row in
                        MetricRow(row: row).environmentObject(model)
                    }
                }
            }.navigationTitle("Metrics").onChange(of: sortOrder) { _, sortOrder in
                self.model.data?.sort(using: sortOrder)
            }
        }
    }
}

struct MetricRow: View {
    @EnvironmentObject private var metrics: MetricsViewModel
    var row: MetricsModel.Metric
    
    var fontWeight: Font.Weight {
        switch metrics.body.type {
        case .url:
            return self.metrics.filters.filters.url == row.x ? .bold : .regular
        case .referrer:
            return self.metrics.filters.filters.referrer == row.x ? .bold : .regular
        default: return .regular
        }
    }
    var body: some View {
        GridRow {
            Text("\(row.y)").fontWeight(.bold)
            Text(metrics.rowPercFormatted(value: row.y) ?? "")
         
            Text("\(row.x)").lineLimit(1).font(.subheadline).foregroundColor(.base800).truncationMode(/*@START_MENU_TOKEN@*/ .tail/*@END_MENU_TOKEN@*/)
            
        }.onTapGesture {
            switch metrics.body.type {
            case .url:
                self.metrics.filters.filters.url = row.x
            case .referrer:
                self.metrics.filters.filters.referrer = row.x
            default: return
            }
        
        }.fontWeight(fontWeight)
    }
}

#Preview {
    NavigationStack {
        WebsiteDetail(websiteId: "31de6a02-3b36-44c8-9d1c-ddbda7f8ea1e", filters: FiltersModel())
    }
}
