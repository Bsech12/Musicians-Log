//
//  TodoItem.swift
//  Musician's Log
//
//  Created by Bryce Sechrist on 11/21/24.
//

import SwiftUI

struct TodoItem: View {
    @Bindable var item: ToDoStorage
    
    var body: some View {
        HStack {
            if item.completed {
                Image(systemName: "checkmark.circle.fill")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                
            } else {
                Image(systemName: "circle")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                
            }
            Text(item.title)
            
        }
    }
}

#Preview {
    List {
        TodoItem(item: ToDoStorage(title: "This is something I need to do!"))
        TodoItem(item: ToDoStorage(title: "This is something I need to do!"))
    }
    
}
