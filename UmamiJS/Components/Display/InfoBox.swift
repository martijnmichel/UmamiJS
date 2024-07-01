//
//  InfoBox.swift
//  UmamiJS
//
//  Created by Martijn van der Eijk on 26/06/2024.
//

import SwiftUI
import AwesomeEnum
struct WebsiteStatBox: View {
    var label, value: String
    var perc: Int
    var icon: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
           Text("\(value)").font(.title).contentTransition(.numericText())
            
            HStack {
                Text(LocalizedStringKey(label)).font(.footnote).foregroundColor(Color(UIColor.systemGray2))
                Text("\(perc)%").font(.caption).fontWeight(.bold).foregroundColor(perc == 0 ? .orange : perc < 0 ? .red : .green).fixedSize().padding(4).background(perc == 0 ? .orange.opacity(0.3) : perc < 0 ? .red.opacity(0.3) : .green.opacity(0.3)).cornerRadius(4)
            }
        }.frame(maxWidth: .infinity, alignment: .topLeading)
    }
}

#Preview {
    VStack {
        WebsiteCard(websiteId: "31de6a02-3b36-44c8-9d1c-ddbda7f8ea1e", filters: FiltersModel()).padding()
        
        ScrollView(.horizontal) {
            HStack {
                WebsiteStatBox(label: "Some", value: "123", perc: 0, icon: "gear")
                
                WebsiteStatBox(label: "Some", value: "123", perc: 0, icon: "user")
                WebsiteStatBox(label: "Some", value: "123", perc: 0, icon: "user")
                
                WebsiteStatBox(label: "Some", value: "123", perc: 0, icon: "user")
                WebsiteStatBox(label: "Some", value: "123", perc: 0, icon: "user")
            }.padding()
        }
    }
}
