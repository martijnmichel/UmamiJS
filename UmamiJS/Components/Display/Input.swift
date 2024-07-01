//
//  Input.swift
//  UmamiJS
//
//  Created by Martijn van der Eijk on 25/06/2024.
//

import SwiftUI

struct Input: ViewModifier {
    
    
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(.base50)
            .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.base200, lineWidth: 1.5)
                )
    }
}


extension View {
    func input() -> some View {
        modifier(Input())
    }
    
}

#Preview {
    @State var bla = ""
    return TextField("Test", text: $bla).input().padding()
}
