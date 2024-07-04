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
            
            
            WebsiteStatBox(label: "Bounce rate", value: "\(model.bounceRatePerc)%", perc: model.bounceRatePerc.perc(b: model.bounceRatePrevPerc), icon:  "icon", contrast: true)
            
            WebsiteStatBox(label: "Time", value: "\(Duration.seconds(model.visitTime).formatted(.units(width: .narrow)))", perc: model.visitTime.perc(b: model.visitTimePrev), icon:  "icon")
            
        }
        
    }
}
#Preview {
    VStack {
        WebsiteCard(websiteId: "45c95e53-e708-489a-bdef-56e9aca68099", filters: FiltersModel())
        WebsiteCard(websiteId: "31de6a02-3b36-44c8-9d1c-ddbda7f8ea1e", filters: FiltersModel())
    }.padding()
}


extension Int {
    func perc(b: Int) -> Int {
        if (self == 0 || b == 0) { return 0 }
        // decrease
        
        let original = Double(b)
        let new = Double(self)
        if (original > new) {
            print("decrease: new -> \(new), original -> \(original), perc -> \((original - new) / original * 100.0)")
            return -Int((original - new) / original * 100.0)
            // increase
        } else if (original < new) {
            print("increase: new -> \(new), original -> \(original), perc -> \((new - original) / original * 100.0)")
            return Int((new - original) / original * 100.0)
        } else { return 0 }
    }
}
