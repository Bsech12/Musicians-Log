//
//  AddTodoPopup.swift
//  Musician's Log
//
//  Created by Bryce Sechrist on 11/22/24.
//

import SwiftUI

struct AddTodoPopup: View {
    
    @Environment(\.modelContext) var modelContext
    
    @Binding var showPopup: Bool
    
    @State var name: String = ""
    @State var description: String = ""
    
    @State var date: Date = Date()
    @State var importance: Importance = .none
    
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
            }
            Button() {
                var newTodo: ToDoStorage = ToDoStorage(title: name, importance: importance, dueDate: date)
                modelContext.insert(newTodo)
                try? modelContext.save()
                showPopup = false
            } label: {
                HStack {
                    Image(systemName: "plus")
                    Text("Add")
                }

            }
            .buttonStyle(.borderedProminent)

        }
        .background(Color.listGrey)
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
