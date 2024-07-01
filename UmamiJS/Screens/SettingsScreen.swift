//
//  SettingsScreen.swift
//  UmamiJS
//
//  Created by Martijn van der Eijk on 27/06/2024.
//

import SwiftUI

struct SettingsScreen: View {
    @EnvironmentObject var model: WebsitesViewModel
    
    @State private var addModel = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(model.websites ?? []) { website in
                    NavigationLink {
                        Text(website.name)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(website.name).font(.headline)
                            Text(website.domain).font(.caption).foregroundColor(.base600)
                        }
                    }
                }.onDelete(perform: { indexSet in
                    withAnimation {
                        model.removeWebsite(at: indexSet)
                    }

                }).listRowBackground(Color.base100).listRowSeparator(.hidden)
            }.scrollContentBackground(.hidden).listRowSpacing(5)
           
        }.navigationTitle("Settings").toolbar {
            Button {
                print("add")
                addModel = true
                
            } label: {
                Image(systemName: "plus")
            }
        }.sheet(isPresented: $addModel) {
            VStack {
                Text(LocalizedStringKey("Add website"))
                AddWebsiteForm()
            }.padding().background(.base100).presentationDetents([.height(300)])
        }
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        @ObservedObject var model = WebsitesViewModel()
        
        return NavigationStack {
            SettingsScreen()
        }.environmentObject(model)
    }
}
