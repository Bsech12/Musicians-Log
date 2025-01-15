//
//  AddTodoPopup.swift
//  Musician's Log
//
//  Created by Bryce Sechrist on 11/22/24.
//

import SwiftUI
import SwiftData

struct AddTodoPopup: View {
    
    @Query(sort: \Tag.name) var tagTypes: [Tag]
    @Environment(\.modelContext) var modelContext
    
    @Binding var showPopup: Bool
    
    @State var name: String = ""
    @State var description: String = ""
    
    @State var date: Date = Date()
    @State var importance: Importance = .none
    
    @State var tags: [Tag] = []
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button("Cancel") {
                    showPopup = false
                }
                .padding()
            }
            Text("Add Todo")
                .font(.headline)
            Form {
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
                Section {
                    DatePicker("Due Date", selection: $date)
                }
                Section("Tags") {
                    FlowHStack {
                        ForEach(tagTypes) { i in
                            TagWidget(tag: i, isGrey: !tags.contains(i), onTagTapped: onTagTapped)
                        }
                    }
                    .padding()
                }
            }
            Button() {
                var newTodo: ToDoStorage = ToDoStorage(title: name, tags: tags, importance: importance, dueDate: date)
                modelContext.insert(newTodo)
                try? modelContext.save()
                showPopup = false
            } label: {
                HStack {
                    Image(systemName: "plus")
                    Text("Add")
                }
                .frame(maxWidth: .infinity, maxHeight: 30)

            }
            .padding()
            .buttonStyle(.borderedProminent)

        }
        .background(Color.listGrey)
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
    @Previewable @State var showPopup: Bool = true
    Button("view") {
        showPopup = true
    }
        .popover(isPresented: $showPopup) {
            AddTodoPopup(showPopup: $showPopup)
        }

//    AddTodoPopup(showPopup: $showPopup)
}
