//
//  AddTodoPopup.swift
//  Musician's Log
//
//  Created by Bryce Sechrist on 11/22/24.
//

import SwiftUI

struct AddTodoPopup: View {
    @State var name: String = ""
    @State var date: Date = Date()
    @State var importance: Importance = .none
    
    var body: some View {
        Form {
            TextField("Name", text: $name)
            DatePicker("Due Date", selection: $date)
            
        }
    }
}

#Preview {
    AddTodoPopup()
}
