//
//  TodoWidget.swift
//  Musician's Log
//
//  Created by Bryce Sechrist on 11/21/24.
//

import SwiftUI
import SwiftData

struct TodoWidget: View {
    
    @Query(sort: \ToDoStorage.dateCreated) var toDos: [ToDoStorage]
    
    var body: some View {
        VStack {
            Text("Todo:")
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            VStack {
                ForEach(toDos) { todo in
                    TodoItem(item: todo)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
        }
    }
}

#Preview {
    TodoWidget()
        .padding(40)
        .border(.gray)
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 25, height: 25)))
        .frame(minWidth: 300, minHeight: 300)
}
