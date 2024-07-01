//
//  AddWebsiteForm.swift
//  UmamiJS
//
//  Created by Martijn van der Eijk on 27/06/2024.
//

import SwiftUI

struct AddWebsiteForm: View {
    
    @EnvironmentObject var model: WebsitesViewModel
    @State private var name: String = ""
    @State private var domain: String = ""
    @State private var sheetHeight: CGFloat = .zero
    var body: some View {
        
            
                
                
        HStack {
            VStack {
                TextField(LocalizedStringKey("Name"), text: $name).input()
                TextField(LocalizedStringKey("Domain"), text: $domain).input()
                Button(LocalizedStringKey("Submit")) {
                    model.addWebsite(params: WebsitesModel.AddWebsiteBody(name: name, domain: domain))
                }.padding()
            }.padding()
        }.frame(maxHeight: .infinity)
        
    }
}

#Preview {
    NavigationStack {
        SettingsScreen().environmentObject(WebsitesViewModel())
    }
}

extension String {
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}

