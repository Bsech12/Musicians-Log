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
    @State var timeSoFar: String = "00:00"
    
    @Environment(\.modelContext) var modelContext
    
    let timer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()
    
    var body: some View {
        Button {
            if(isRecording) {
                stopRecording()
            } else {
                startRecording()
            }
        } label: {
            HStack {
                VStack {
                    Text(isRecording ? "Recording" : "Record")
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Latest: \(timeSoFar)")
                        .onReceive(timer) {_ in
                            if (isRecording) {
                                let difference = currentRecording.startTime.differenceBetween(dateToUse: Date())
                                self.timeSoFar = "\(difference.minute ?? 0):\(difference.second ?? 0)"
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Image(systemName: "record.circle")
                    .scaledToFit()
                    .foregroundStyle(.red)
            }
            .padding()
            .popover(isPresented: $isPopoverPresented) {
                NewTimer(isPresented: $isPopoverPresented, log: $currentRecording, isStarted: $isRecording)
            }
        }
        

        
    }
    
    func startRecording() {
        currentRecording = MusicLogStorage(title: "New Recording")
        isPopoverPresented = true
    }
    
    func stopRecording() {
        isRecording = false
        currentRecording.endTime = Date()
        modelContext.insert(currentRecording)
        try? modelContext.save()

    }
}

#Preview {
    Button {
        //As an example
    } label: {
        RecordWidget()
            
    }
    .buttonBorderShape(.roundedRectangle)
    .buttonStyle(.bordered)
    .padding(40)

}
