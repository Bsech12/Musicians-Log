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
    
    @State var recordings: [RecorderClass] = []
    @State var recordingsToDelete: [RecorderClass] = []

    @State var confirmationShown = false
    @State var deleteRecording: Bool = false

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
                    Section("Recordings") {
                        ForEach(recordings, id: \.self) { i in
                            HStack {
                                Button {
                                    print("totally working")
                                    deleteRecording = true
                                } label: {
                                    Image(systemName: "trash")
                                        .foregroundStyle(Color.red)
                                    
                                }
                                .padding()
                                .buttonStyle(.plain)
                                
                                RecordingButton(recordingClass: i)
                                    .alert(isPresented: $deleteRecording) {
                                        Alert(title: Text("Confirm Recording Deletion"),
                                              message: Text("Are you sure you want to delete this Recording? Onced saved, this and action cannot be undone"),
                                              primaryButton: .destructive(Text("Delete")) {
                                            withAnimation {
                                                recordings.removeAll(where: { $0 == i })
                                                recordingsToDelete.append(i)
                                            }
                                        },
                                              secondaryButton: .cancel())
                                        
                                    }
                            }
                        }
                    }
                    Section("Completed Tasks") {
                        ForEach(calendarItem.todosCompleted, id: \.self) { todo in
                            TodoItem(item: todo)
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
                        } else {
                            confirmationShown = true
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
                    Section("Recordings") {
                        ForEach(recordings, id: \.self) { i in
                            RecordingButton(recordingClass: i)
                        }
                    }
                    Section("Completed Tasks") { //TODO: not done yet
                        ForEach(calendarItem.todosCompleted, id: \.self) { todo in
                            TodoItem(item: todo)
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
            .alert("Are you sure you want to delete?", isPresented: $confirmationShown) {
                Button("Delete", role: .destructive) {
                    modelContext.delete(calendarItem)
                }
                Button("Cancel", role: .cancel) {
                    confirmationShown = false
                }
            } message: {
                Text("This cannot be undone")
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
                        for r in recordingsToDelete {
                            r.deleteFile()
                            calendarItem.recordings.removeAll { $0 == r.fileName }
                        }
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
        .background(Color.listGrey)

    }
    
    func updateEditableInfo() {
        title = calendarItem.title
        tags = calendarItem.tags
        notes = calendarItem.notes
        startingDate = calendarItem.startTime
        recordings.removeAll()
        recordingsToDelete.removeAll()
        
        for recording in calendarItem.recordings {
            recordings.append(RecorderClass(recordingName: recording))
        }
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
