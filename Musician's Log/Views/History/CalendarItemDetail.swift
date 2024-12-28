//
//  CalendarItemDetail.swift
//  Musician's Log
//
//  Created by Bryce Sechrist on 12/25/24.
//

import SwiftUI
import SwiftData

struct CalendarItemDetail: View {
    
    @Query(sort: \Tag.name) var tagTypes: [Tag]
    @Environment(\.modelContext) var modelContext
    
    @Binding var isNew: Bool
    
    @Bindable var calendarItem: MusicLogStorage
    @State var editMode: EditMode = .inactive
    @State var isEditing = false
    
    @State var title: String = ""
    
    @State var startingDate: Date = Date()
    @State var startingStringDate: String = ""

    @State var endingDate: Date?
    @State var endingStringDate: String = ""
    
    @State var totalTimeString: String = ""
    
    @State var tags: [Tag] = []
    @State var notes: String = ""

    
    var body: some View {
        VStack {
            if(isNew) {
                HStack {
                    Spacer()
                    Button("Cancel") {
                        isNew = false
                    }
                    .padding()
                }
                Text(title)
                    .font(.headline)
                    .onAppear()
                {
                    isEditing = true
                }
                
            }
            Form { // MARK: Editing
                if isEditing {
                    Section("Title") {
                        TextField("title", text: $title)
                    }
                    Section("Date") {
                        DatePicker("Start Date:", selection: $startingDate)
                            .onChange(of: startingDate) {
                                updateTotalTime()
                            }
                        if endingDate != nil {
                            DatePicker("End Date: ", selection: Binding($endingDate)!)
                                .onChange(of: endingDate) {
                                    updateTotalTime()
                                }
                        } else {
                            Button("Add end date") {
                                endingDate = Date()
                            }
                        }
                        
                    }
                    
                    Section("Data") {
                        
                        
                        DetailRow("Total Time:", totalTimeString)
                        
                        //how long,
                        //how good?
                        //recordings?
                        
                    }
                    Section("Tags") {
                        FlowHStack {
                            ForEach(tagTypes) { i in
                                TagWidget(tag: i, isGrey: !tags.contains(i), onTagTapped: onTagTapped)
                            }
                        }
                        .padding()
                    }
                    Section("Completed Tasks") {
                        ForEach(calendarItem.todosCompleted, id: \.self) { todo in
                            TodoItem(name: todo.title, checked: todo.completed)
                        }
                        
                        if(calendarItem.todosCompleted.isEmpty) {
                            Text("No tasks completed")
                        }
                    }
                    Section("Notes") {
                        TextField("Notes", text: $notes, axis: .vertical)
                            .lineLimit(5...10)
                        
                    }
                    Button(isNew ? "Add" : "Delete")
                    {
                        if isNew { //adding new
                            calendarItem.title = title
                            calendarItem.tags = tags
                            calendarItem.notes = notes
                            calendarItem.startTime = startingDate
                            calendarItem.endTime = endingDate
                            
                            isEditing.toggle()
                            updateEditableInfo()
                            modelContext.insert(calendarItem)
                            try? modelContext.save()
                            isNew = false
                        } else { //delete
                            //are you sure?
                        }
                        
                    }
                    .foregroundStyle(isNew ? .blue : .red)
                } else { // MARK: Not editing
                    Section("Date") {
                        DetailRow("Start Date:", startingStringDate)
                        
                        DetailRow("End Date:", endingStringDate)
                        
                    }
                    Section("Data") {
                        DetailRow("Total Time:", totalTimeString)
                        
                        //how long,
                        //how good?
                        //recordings?
                        
                    }
                    Section("Tags") {
                        FlowHStack {
                            ForEach(tags, id: \.self) { tag in
                                TagWidget(tag: tag, doesToggle: false)
                            }
                            if(tags.isEmpty) {
                                Text("No tags")
                            }
                        }.padding()
                        
                    }
                    Section("Completed Tasks") { //TODO: not done yet
                        ForEach(calendarItem.todosCompleted, id: \.self) { todo in
                            TodoItem(name: todo.title, checked: todo.completed)
                        }
                        
                        if(calendarItem.todosCompleted.isEmpty) {
                            Text("No tasks completed")
                        }
                    }
                    Section("Notes") {
                        Text(notes)
                            .lineLimit(5...10)
                    }
                    
                }
            }
            .toolbar {
                if(isEditing) {
                    Button("Cancel") {
                        updateEditableInfo()
                        isEditing.toggle()
                    }
                    .foregroundStyle(.red)
                }
                Button(isEditing ? "Save" : "Edit") {
                    if isEditing { // save
                        calendarItem.title = title
                        calendarItem.tags = tags
                        calendarItem.notes = notes
                        calendarItem.startTime = startingDate
                        calendarItem.endTime = endingDate
                    }
                    
                    isEditing.toggle()
                    updateEditableInfo()
                }
                
            }
            .environment(\.editMode, $editMode)
            .onChange(of: isEditing) {
                editMode = isEditing ? .active : .inactive
            }
            .navigationTitle(calendarItem.title)
            .onAppear() {
                updateEditableInfo()
            }
        }

    }
    
    func updateEditableInfo() {
        title = calendarItem.title
        tags = calendarItem.tags
        notes = calendarItem.notes
        startingDate = calendarItem.startTime
        if let endTime = calendarItem.endTime {
            endingDate = endTime
            endingStringDate = endTime.formatted(date: .numeric, time: .standard)
        } else {
            endingStringDate = "--:--"
        }
        
        startingStringDate = startingDate.formatted(date: .numeric, time: .standard)
        updateTotalTime()
    }
    
    func updateTotalTime() {
        if let endTime = endingDate {
            let difference = Calendar.current.date(from: calendarItem.startTime.differenceBetween(dateToUse: endTime))
            
            let formatter: DateFormatter = {
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm:ss"
                return formatter
            }()
            
            totalTimeString = formatter.string(from: difference!)
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
    @Previewable @State var calendarItem: MusicLogStorage = MusicLogStorage(title: "New Item", tags: [Tag(name: "piano", icon: "", color: .blue), Tag(name: "cello", icon: "", color: .red)])
    
    
    NavigationView {
        CalendarItemDetail(isNew: .constant(false), calendarItem: calendarItem)
    }
//    .onAppear()
//    {
//        calendarItem.todosCompleted.append(ToDoStorage(title: "A Todo", tags: [], notes: "", completed: true))
//        calendarItem.todosCompleted.append(ToDoStorage(title: "Another Todo", tags: [], notes: "", completed: true))
//        calendarItem.endTime = Date().addingTimeInterval(2564)
//        calendarItem.notes = "This is a note with a long text so that it will eventually go to the next line. I hope it works!"
//    }
}
