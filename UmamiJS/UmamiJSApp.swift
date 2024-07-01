//
//  UmamiJSApp.swift
//  UmamiJS
//
//  Created by Martijn van der Eijk on 22/06/2024.
//

import SwiftUI

@main
struct UmamiJSApp: App {
    @ObservedObject var userStateViewModel = UserStateViewModel()
    @AppStorage("Token") var token = ""

    var body: some Scene {
        WindowGroup {
            NavigationView {
                ApplicationSwitcher()
            }
            .navigationViewStyle(.stack)
            .environmentObject(userStateViewModel)
            
            
        }
    }
}

struct ApplicationSwitcher: View {
    @EnvironmentObject var vm: UserStateViewModel

    var body: some View {
        VStack {
            if vm.isLoggedIn {
                ContentView()
            } else {
                LoginView()
            }
        }.onAppear(perform: {
            Task {
                print("re-login")
                var re = await vm.verify()
                print(re)
            } /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Code@*/ /*@END_MENU_TOKEN@*/
        })
        
    }
}

struct UmamiJSApp_Previews: PreviewProvider {
    static var previews: some View {
        @ObservedObject var userStateViewModel = UserStateViewModel()
        @ObservedObject var websitesModel = WebsitesViewModel()
        
     

        return NavigationView {
            ApplicationSwitcher()
        }
        .navigationViewStyle(.stack)
        .environmentObject(userStateViewModel).environmentObject(websitesModel)
    }
}
