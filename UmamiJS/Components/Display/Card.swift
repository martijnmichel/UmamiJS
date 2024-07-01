//
//  Card.swift
//  UmamiJS
//
//  Created by Martijn van der Eijk on 23/06/2024.
//

import SwiftUI

struct Card: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: .leading)
            
            .background(.base100)
            .cornerRadius(10)
            .shadow(color: .base200, radius: 2)
    }
}


struct CardContent: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding().foregroundColor(.primary)
    }
}


struct CardTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline).foregroundColor(.primary)
    }
}

extension View {
    func card() -> some View {
        modifier(Card())
    }
    
    func cardContent() -> some View {
        modifier(CardContent())
    }
    
    func cardTitle() -> some View {
        modifier(CardTitle())
    }
}

#Preview {
    Grid {
        GridRow {
            VStack {
                Text("hoi").cardTitle().padding()
                Text("dit is wat tekst").cardContent()
            }.card()
            
                VStack {
                    Text("hoi").cardTitle().padding()
                    Text("dit is wat tekst").cardContent()
                }.card()
            
          
        }
        
        GridRow {
            VStack {
                Text("hoi").cardTitle().padding()
                Text("dit is wat tekst").cardContent()
            }.card()
            
                VStack {
                    Text("hoi").cardTitle().padding()
                    Text("dit is wat tekst").cardContent()
                }.card()
            
          
        }
        
        GridRow {
            VStack {
                Text("hoi").cardTitle().padding()
                Text("dit is wat tekst").cardContent()
            }.card()
            
                VStack {
                    Text("hoi").cardTitle().padding()
                    Text("dit is wat tekst").cardContent()
                }.card()
            
          
        }
        
    }.padding()
}
