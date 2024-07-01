//
//  ContentView.swift
//  UmamiJS
//
//  Created by Martijn van der Eijk on 22/06/2024.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var vm: UserStateViewModel
    
    @ObservedObject var model = WebsitesViewModel()
    
    @ObservedObject private var filters = FiltersModel()
    @State private var navPath = NavigationPath()
        
    var body: some View {
        if vm.isBusy {
            ProgressView()
        } else  {
            TabView {
                NavigationStack(path: $navPath) {
                    VStack {
                            ScrollView {
                                VStack {
                                    ForEach(model.websites ?? []) { website in
                                        NavigationLink(value: website) {
                                            WebsiteCard(websiteId: website.id, filters: filters).navigationDestination(for: WebsiteDetailsModel.Website.self) {
                                                
                                                site in WebsiteDetail(websiteId: site.id)
                                            }
                                        }
                                        
                                    }
                                    
                                    
                                }.padding()
                                
                            }
                    }.navigationTitle("Welcome \(vm.user?.username ?? "anon")").toolbar {
                        Button {
                            Task {
                                await vm.signOut()
                            }
                            
                        } label: {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                        }
                    }
                }.tabItem {
                    Label("Dashboard", systemImage: "chart.pie")
                }
                
                NavigationStack {
                    SettingsScreen()
                }.tabItem {
                    Label("Settings", systemImage: "gear")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    
        @ObservedObject static var userStateViewModel = UserStateViewModel()
        @ObservedObject static var websiteModel = WebsitesViewModel()
    
    static var previews: some View {
        NavigationStack {
            ContentView().environmentObject(userStateViewModel)
        }
    }
}
