//
//  Main.swift
//  UmamiJS
//
//  Created by Martijn van der Eijk on 25/06/2024.
//

import SwiftUI

struct Main: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(.white)
            .cornerRadius(10)
            .shadow(color: Color.gray.opacity(0.05), radius: 2)
            .clipShape(.rect(cornerRadius: 10))
    }
}


extension View {
    func mainLayout() -> some View {
        modifier(Main())
    }
    
}
