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
    var contrast: Bool? = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
           Text("\(value)").font(.title).contentTransition(.numericText())
            
            
            HStack {
                Text(LocalizedStringKey(label)).font(.footnote).foregroundColor(Color(UIColor.systemGray2))
                Text("\(perc)%").font(.caption).fontWeight(.bold).foregroundColor(perc == 0 ? .orange : perc < 0 || (perc > 0 && contrast == true) ? .red : .green).fixedSize().padding(4).background(perc == 0 ? .orange.opacity(0.3) : perc < 0 || (perc > 0 && contrast == true) ? .red.opacity(0.3) : .green.opacity(0.3)).cornerRadius(4)
            }
        }.frame(maxWidth: .infinity, alignment: .topLeading)
    }
}

#Preview {
    VStack {
        WebsiteCard(websiteId: "0affd8a5-dc17-43e3-b031-399f37cc9a2a", filters: FiltersModel()).padding()
        
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
