//
//  NewTimer.swift
//  Musician's Log
//
//  Created by Bryce Sechrist on 12/17/24.
//

import SwiftUI
import SwiftData

struct NewTimer: View {
    @Binding var isPresented: Bool
    @Binding var log: MusicLogStorage
    @Binding var isStarted: Bool
    
    @State var title: String = "New Event"
    @State var tags: [Tag] = []
    
    @State var notes: String = ""
    
    @Query(sort: \Tag.name) var tagTypes: [Tag]
    
    var body: some View {
        HStack {

            Spacer()
            Button("Cancel") {
                isPresented = false
            }
            .padding()
        }
        Text("New Timer")
            .font(.headline)
            .foregroundStyle(.primary)

        Form {
            Section("Title") {
                TextField("Title", text: $title)
            }
            Section("tags") {
                FlowHStack {
                    ForEach(tagTypes) { i in
                        TagWidget(tag: i, isGrey: tags.contains(i), onTagTapped: onTagTapped)
                    }
                }
                .padding()
            }

            Section("Notes") {
                TextField("Notes", text: $notes, axis: .vertical)
                    .lineLimit(5...10)
            }
            
        }
        .onAppear {
            title = log.title
            tags = log.tags
            notes = log.notes
        }
 
        
        
        
        
        Button {
            isPresented = false
            isStarted = true
            log.startTime = Date()
        } label: {
            Text("Start!!")
                .frame(maxWidth: .infinity, maxHeight: 30)
        }
        .padding()
        .buttonStyle(.borderedProminent)
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
    @Previewable @State var isPresented: Bool = true
    @Previewable @State var log: MusicLogStorage = MusicLogStorage(title: "ello", tags: [Tag(name: "Piano", icon: "", color: .red), Tag(name: "cello", icon: "", color: .blue)], notes: "These are some notes!")
    @Previewable @State var isStarted: Bool = false
    Button("popover")
    {
        isPresented = true
    }
        .popover(isPresented: $isPresented) {
            NewTimer(isPresented: $isPresented, log: $log, isStarted: $isStarted)
        }
    
}
