//
//  TodoItem.swift
//  Musician's Log
//
//  Created by Bryce Sechrist on 11/21/24.
//

import SwiftUI

struct TodoItem: View {
    @State var name: String
    @State var checked: Bool
    
    var body: some View {
        HStack {
            if checked {
                Image(systemName: "checkmark.circle.fill")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                
            } else {
                Image(systemName: "circle")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                
            }
            Text(name)
            
        }
    }
}

#Preview {
    List {
        TodoItem(name: "This is something I need to do!", checked: true )
        TodoItem(name: "This is something I need to do!", checked: false )
    }
    
}
