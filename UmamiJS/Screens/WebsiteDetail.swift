//
//  WebsiteDetail.swift
//  UmamiJS
//
//  Created by Martijn van der Eijk on 23/06/2024.
//

import Combine
import SwiftUI

struct WebsiteDetail: View {
    @AppStorage("startAt") var startAt: String = ""
    var websiteId: String
    
    @ObservedObject private var filtersModel: FiltersModel
    @ObservedObject private var model: WebsiteDetailViewModel
    @ObservedObject private var pageviewModel: PageviewsViewModel
    @ObservedObject private var statsModel: StatsViewModel
    @ObservedObject private var metricsModel: MetricsViewModel
    @ObservedObject private var referrers: MetricsViewModel
    
    @State private var navPath = NavigationPath()
    
    init(websiteId: String, filters: FiltersModel) {
        print("INIT")
        self.websiteId = websiteId
        self.filtersModel = filters
        self.model = WebsiteDetailViewModel(websideId: websiteId)
        self.pageviewModel = PageviewsViewModel(websiteId: websiteId, manager: filters)
        self.statsModel = StatsViewModel(websideId: websiteId, manager: filters)
        self.metricsModel = MetricsViewModel(websideId: websiteId, manager: filters)
        self.referrers = MetricsViewModel(websideId: websiteId, manager: filters)
        
        self.referrers.body.type = .referrer
        
        self.referrers.getMetrics()
        self.metricsModel.getMetrics()
        self.statsModel.getStats()
        self.pageviewModel.getPageviews()
        self.model.getWebsite()
    }
    
    var body: some View {
        if self.model.website == nil {
            ProgressView()
        } else {
            VStack {
                ScrollView(.horizontal) {
                    LazyHGrid(rows: [GridItem()]) {
                        WebsiteStats(model: self.statsModel)
                        
                    }.padding(.horizontal)
                }.frame(height: 100)
                ScrollView {
                    Section {
                        Button("last 30 days") {
                            print(self.filtersModel.filters.startAt)
                            // func below should calculate diff between startAt and endAt and update .unit accordingly, however, it works
                            self.pageviewModel.body.unit = .day
                            self.filtersModel.filters.startAt = Calendar.current.date(byAdding: .month, value: -3, to: Date())!
                            print(self.filtersModel.filters.startAt)
                        }
                        
                        Button("clear") {
                            filtersModel.clear()
                        }
                    }
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading) {
                            Text(LocalizedStringKey("Pageviews")).cardTitle().padding()
                            PageviewChart(model: self.pageviewModel).cardContent()
                        }.card()
                                
                        NavigationLink(value: self.metricsModel.body) { VStack(alignment: .leading) {
                            Text(LocalizedStringKey("Metrics")).cardTitle().padding()
                            ScrollView(.horizontal) {
                                Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 10) {
                                    ForEach(self.metricsModel.limitFirst10) { row in
                                        MetricRow(row: row).environmentObject(self.metricsModel)
                                    }
                                }.cardContent()
                            }
                                
                        }.card() }.navigationDestination(for: MetricsModel.GetMetricsBody.self) {
                            _ in MetricsTable(model: self.metricsModel)
                        }
                    }.padding()
                    
                    VStack(alignment: .leading) {
                         VStack(alignment: .leading) {
                            Text(LocalizedStringKey("Referrers")).cardTitle().padding()
                            ScrollView(.horizontal) {
                                Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 10) {
                                    GridRow {
                                        Text("Views")
                                        Text("View %")
                                        Text("Referrers")
                                    }.font(.headline)
                                    ForEach(self.referrers.limitFirst10) { row in
                                        MetricRow(row: row).environmentObject(self.referrers)
                                    }
                                }.cardContent()
                            }
                                
                        }.card() 
                    }.padding()
                }
            }.environmentObject(self.pageviewModel).navigationTitle(self.model.website?.name ?? "")
        }
    }
}

struct WebsiteDetail_Previews: PreviewProvider {
    @ObservedObject static var filters = FiltersModel()
    static var previews: some View {
        NavigationStack {
            WebsiteDetail(websiteId: "31de6a02-3b36-44c8-9d1c-ddbda7f8ea1e", filters: filters)
        }
    }
}
