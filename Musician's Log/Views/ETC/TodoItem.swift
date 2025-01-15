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
        VStack {
            HStack {
                Button {
                    item.completed = !item.completed
                } label: {
                    HStack {
                        if item.importance == .veryHigh {
                            Text("!!!!")
                        } else if(item.importance == .high) {
                            Text("!!!")
                        } else if(item.importance == .medium) {
                            Text("!!")
                        } else if (item.importance == .low) {
                            Text("!")
                        }
                    }
                    .padding(.leading, -15)
                    .padding(.trailing, -10)
                    .foregroundStyle(item.importance.toColor())
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
                        
                        
                    }
                }
                .buttonStyle(.plain)
                NavigationLink(destination: TodoDetail(selectedTodo: item)) {
                    Text(item.title)
                        .foregroundStyle(item.completed ? .secondary : .primary)
                    
                }
            }
            HStack {
                
                if item.tags.count > 0 {
                    ForEach(0...item.tags.count - 1, id: \.self) { i in

                            
                            item.tags[i].getColor()
                                .clipShape(Circle())
                                .padding(.top, -5)
                                .frame(width: 9, height: 9)
                    }
//                    if item.tags.count > 4 {
//                        Text(" ...")
//                            .foregroundStyle(.white)
//                            .padding(.top, -12)
//                            .frame(height: 0)
//                    }
                }
                Spacer()
            }
        }
    }
}

#Preview {
    NavigationView {
        List {
            TodoItem(item: ToDoStorage(title: "This is something I need to do!", tags: [Tag(name: "Piano", icon: "", color: .red)],importance: .veryHigh))
            TodoItem(item: ToDoStorage(title: "This is something I need to do!", importance: .high))
            TodoItem(item: ToDoStorage(title: "This is something I need to do!", importance: .medium))
            TodoItem(item: ToDoStorage(title: "This is something I need to do!", importance: .low))
            TodoItem(item: ToDoStorage(title: "This is something I need to do!", importance: .none))
        }
    }
}
