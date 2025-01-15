//
//  TodoDetail.swift
//  Musician's Log
//
//  Created by Bryce Sechrist on 1/5/25.
//

import SwiftUI
import SwiftData

struct TodoDetail: View {
    @Bindable var selectedTodo: ToDoStorage
    @State var isEditing: Bool = false
    
    @Query(sort: \Tag.name) var tagTypes: [Tag]
    @Environment(\.modelContext) var modelContext
    
    @State var name: String = ""
    
    @State var isCompleted: Bool = false
    @State var importance: Importance = .low
//    @State var dateCreated: Date = Date()
//    @State var dateCompleted: Date?
        
    @State var tags: [Tag] = []
    
    @State var description: String = ""
    
    @State var confirmationShown = false
    
    
    var body: some View {
        List {
            if isEditing {
                Section {
                    TextField("Name", text: $name)
                    Picker("Importance", selection: $importance) {
                        Text("None").tag(Importance.none)
                        Text("Low").tag(Importance.low)
                            .foregroundStyle(.blue)
                        Text("Medium").tag(Importance.medium)
                            .foregroundStyle(.yellow)
                        Text("High").tag(Importance.high)
                            .foregroundStyle(.orange)
                        Text("Very High").tag(Importance.veryHigh)
                            .foregroundStyle(.red)
                    }
                    TextField("Description", text: $description)
                        .lineLimit(5...10)
                }

                Section("Tags") {
                    FlowHStack {
                        ForEach(tagTypes) { i in
                            TagWidget(tag: i, isGrey: !tags.contains(i), onTagTapped: onTagTapped)
                        }
                    }
                    .padding()
                }
                
                Section("Actions") {
                    Button(isCompleted ? "Unset Completed" :"Set Completed") {
                        isCompleted.toggle()
                    }
                    .foregroundStyle(.green)
                    Button("Delete") {
                        confirmationShown = true
                    }
                    .foregroundStyle(.red)
                }
            } else {
                Section {
                    DetailRow("Is Completed:", "\(selectedTodo.completed ? "Yes" : "No")")
                    DetailRow("Importance:", "\(selectedTodo.importance)")
                }
                Section("Date") {
                    DetailRow("Date Created:", "\(selectedTodo.dateCreated.formatted(date: .abbreviated, time: .shortened))")
                    DetailRow("Date Completed:", "\(selectedTodo.dateCompleted?.formatted(date: .abbreviated, time: .shortened) ?? "--:--")")
                    DetailRow("Due Date:", "\(selectedTodo.dueDate?.formatted(date: .abbreviated, time: .shortened) ?? "--:--")")
                    DetailRow("Reminder Date:", "\(selectedTodo.reminderDate?.formatted(date: .abbreviated, time: .shortened) ?? "--:--")")
                    //date created,
                    //date completed?
                    //due date
                    //reminder date
                }
                Section("Tags") {
                    FlowHStack {
                        ForEach(selectedTodo.tags, id: \.self) { tag in
                            TagWidget(tag: tag, doesToggle: false)
                        }
                        if(selectedTodo.tags.isEmpty) {
                            Text("No tags")
                                .padding(-10)
                        }
                    }.padding()
                    
                }
                Section("Notes") {
                    Text(selectedTodo.notes)
                        .lineLimit(5...10)
                }
                

            }
        }
        .alert("Are you sure you want to delete?", isPresented: $confirmationShown) {
            Button("Delete", role: .destructive) {
                modelContext.delete(selectedTodo)
            }
            Button("Cancel", role: .cancel) {
                confirmationShown = false
            }
        } message: {
            Text("This cannot be undone")
        }
        .navigationTitle(selectedTodo.title)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if(isEditing) {
                    Button("Cancel") {
                        isEditing = false
                    }
                    .foregroundStyle(.red)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(isEditing ? "Save" : "Edit") {
                    if(isEditing) {
                        selectedTodo.importance = importance
                        selectedTodo.tags = tags
                        selectedTodo.notes = description
//                        selectedTodo.dateCreated = dateCreated
                        selectedTodo.completed = isCompleted
                        selectedTodo.title = name
                    } else {
                        importance = selectedTodo.importance
                        tags = selectedTodo.tags
                        description = selectedTodo.notes
//                        selectedTodo.dateCreated = dateCreated
                        isCompleted = selectedTodo.completed
                        name = selectedTodo.title
                    }
                    
                    isEditing.toggle()
                }
            }
            
        }
        
    }
    
    
    func onTagTapped(tag: Tag) {
    
        if tags.contains(tag) {
                tags.remove(at: tags.firstIndex(of: tag)!)
            
        } else {
            tags.append(tag)
        }
        
    }
    
}

#Preview {
    NavigationView {
        TodoDetail(selectedTodo: ToDoStorage(title: "Test", importance: .low))
    }
}
