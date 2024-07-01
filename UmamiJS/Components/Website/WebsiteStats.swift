//
//  WebsiteCard.swift
//  UmamiJS
//
//  Created by Martijn van der Eijk on 25/06/2024.
//

import SwiftUI

struct WebsiteStats: View {
    
    @ObservedObject var model: StatsViewModel
    
    var body: some View {
        if let stats = self.model.data {
            WebsiteStatBox(label: "Pageviews", value: "\(stats.pageviews.value)", perc: stats.pageviews.value.perc(b: stats.pageviews.prev), icon:  "icon")
            
            WebsiteStatBox(label: "Visits", value: "\(stats.visits.value)", perc: stats.visits.value.perc(b: stats.visits.prev), icon:  "icon")
            
            WebsiteStatBox(label: "Visitors", value: "\(stats.visitors.value)", perc: stats.visitors.value.perc(b: stats.visitors.prev), icon:  "icon")
            
            WebsiteStatBox(label: "Bounce rate", value: "\(stats.bounces.value)", perc: stats.bounces.value.perc(b: stats.bounces.prev), icon:  "icon")
        
            WebsiteStatBox(label: "Time", value: "\(Duration.seconds(stats.visits.value == 0 ? 0 : stats.totaltime.value / stats.visits.value).formatted(.units(width: .narrow)))", perc: stats.totaltime.value.perc(b: stats.totaltime.prev), icon:  "icon")
        }
        
    }
}
#Preview {
    WebsiteCard(websiteId: "45c95e53-e708-489a-bdef-56e9aca68099", filters: FiltersModel()).padding()
}
