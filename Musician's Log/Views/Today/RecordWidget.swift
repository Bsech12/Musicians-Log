//
//  RecordWidget.swift
//  Musician's Log
//
//  Created by Bryce Sechrist on 11/18/24.
//

import SwiftUI
import SwiftData

struct RecordWidget: View {
    
    
    @State var currentRecording: MusicLogStorage = MusicLogStorage(title: "New")
    @State var isPopoverPresented: Bool = false
    @State var isRecording = false
    @State var timeSoFar: String = "00:00:00"
    
    @Environment(\.modelContext) var modelContext
    
    let timer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()
    
    @State var title: String = ""
    @State var tags: [Tag] = []
    @State var recordings: [RecorderClass] = []
    
    @Query(sort: \Tag.name) var tagTypes: [Tag]
    
    
    var body: some View {
        
        
        if isRecording {
            VStack {
                HStack {
                    VStack {
                        Text("Practicing")
                            .font(.title)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding([.top, .horizontal])
                        Text("\(timeSoFar)")
                            .padding(.bottom)
                    }
                    Button{
                        withAnimation {
                            stopRecording()
                        }
                    } label: {
                        Image(systemName: "stop.fill")
                            .foregroundStyle(.red)
                        
                    }
                    .padding()
                }
                HStack {
                    Text("Add Title:")
                        .frame(width: 80, alignment: .leading)
                        .foregroundStyle(.secondary)
                    TextField("", text: $title)
                        .multilineTextAlignment(.leading)
                        .overlay(RoundedRectangle(cornerRadius: 5)
                            .stroke(style: StrokeStyle(lineWidth: 1))
                                 , alignment: .leading)
                }
                .padding()
                Text("Tags:")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                FlowHStack {
                    ForEach(tagTypes) { i in
                        TagWidget(tag: i, smaller: true, isGrey: true, onTagTapped: onTagTapped)
                    }
                }
                LazyVStack {
                    ForEach(recordings, id: \.self) { i in
                        RecordingButton(recordingClass: i)
                    }
                    Button("Add") {
                        recordings.append(RecorderClass(recordingName: UUID().uuidString))
                    }
                    .buttonStyle(.borderedProminent)
                }
                
            }
        } else {
            Button {
                withAnimation {
                    startRecording()
                }
            } label: {
                HStack {
                    VStack {
                        Text("Start Practice")
                            .font(.title)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("Latest: \(timeSoFar)")
                            .onReceive(timer) {_ in
                                if (isRecording) {
                                    let difference = Calendar.current.date(from: currentRecording.startTime.differenceBetween(dateToUse: Date()))
                                    let formatter: DateFormatter = {
                                        let formatter = DateFormatter()
                                        formatter.dateFormat = "HH:mm:ss"
                                        return formatter
                                    }()
                                    
                                    self.timeSoFar = "\(formatter.string(from: difference!))"
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    Image(systemName: "hourglass")
                        .scaledToFit()
                }
                .padding()
            }
        }
        
        
        
    }
    
    func startRecording() {
        currentRecording = MusicLogStorage(title: "")
        isRecording = true
        title = ""
        recordings = []
        tags = []
    }
    
    func stopRecording() {
        isRecording = false
        currentRecording.endTime = Date()
        currentRecording.tags = tags
        currentRecording.title = title
        for recording in recordings {
            currentRecording.recordings.append(recording.fileName)
        }
        modelContext.insert(currentRecording)
        try? modelContext.save()
        
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
    Button {
        //As an example
    } label: {
        RecordWidget(isRecording: true)
        
    }
    .buttonBorderShape(.roundedRectangle)
    .buttonStyle(.bordered)
    .padding(40)
    
}
