//
//  SwiftUIView.swift
//  Memory Lane
//
//  Created by Bryce Sechrist on 2/19/25.
//

import SwiftUI
import AVFoundation

struct RecordingButton: View {
    
    @ObservedObject  var recordingClass: RecorderClass
    
//    @Binding var recordingName: String
    
    @State var hasRecordingYet: Bool = false
    @State var duration: TimeInterval = 0
    
    @Binding var isEditing: Bool
    @State var deleteRecording: Bool = false
    
//    init(recordingName: Binding<String>, isEditing: Binding<Bool>) {
//        self.recordingClass = .init(recordingName: recordingName.wrappedValue)
//        self._recordingName = recordingName
//        self._isEditing = isEditing
//    }
//    
    var body: some View {
        ZStack {
            if isEditing && hasRecordingYet{
                HStack {
                    Button {
                        print("totally working")
                        deleteRecording = true
                    } label: {
                        Image(systemName: "trash")
                            .foregroundStyle(Color.red)
                        
                    }
                    .buttonStyle(.plain)
                    .padding(.leading, -250)
                }
            }
            HStack {
                Text(hasRecordingYet ? "Recording: " :"Add a new Recording: ")
                if(recordingClass.isRecording) {
                    Text("\(recordingClass.recordingDuration.toHMS())")
                } else if(hasRecordingYet) {
                    if recordingClass.timeElapsed == 0 {
                        Text("\(duration.toHMS())")
                    } else {
                        Text("\(recordingClass.timeElapsed.toHMS())/\(duration.toHMS())")
                    }
                }
                Spacer()
                
                if (hasRecordingYet) {
                    if(recordingClass.timeElapsed != 0 && !recordingClass.isPlaying) {
                        Button {
                            recordingClass.audioPlayer?.currentTime = 0
                            recordingClass.updateTimer()
                        } label: {
                            
                            Image(systemName: "arrowshape.turn.up.backward.circle")
                        }
                        .buttonStyle(.plain)
                    }
                    Button {
                        recordingClass.playPause()
                    } label: {
                        if(recordingClass.isPlaying) {
                            Image(systemName: "pause.circle")
                        } else {
                            Image(systemName: "play.circle")
                        }
                    }
                    .buttonStyle(.plain)
                    
                } else {
                    Button {
                        if recordingClass.isRecording {
                            recordingClass.stopRecording()
                            tryHasRecordingYet()
                        } else {
                            recordingClass.startRecording()
                            
                        }
                    } label: {
                        
                        Image(systemName: "record.circle")
                            .foregroundStyle(recordingClass.isRecording ? Color.red : Color.white)
                    }
                    .buttonStyle(.plain)
                }
            }
            .frame(maxWidth: 400)
            
            .padding(10)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray)
            }
            
        }
        .alert(isPresented: $deleteRecording) {
            Alert(title: Text("Confirm Recording Deletion"),
                  message: Text("Are you sure you want to delete this Recording? This and action cannot be undone"),
                  primaryButton: .destructive(Text("Delete")) {
                withAnimation {
//                    recordingName = UUID().uuidString
                    tryHasRecordingYet()
                }
            },
                  secondaryButton: .cancel())
            
        }
        
        .onAppear() {
            tryHasRecordingYet()
        }
//        .onChange(of: recordingName) {
//            tryHasRecordingYet()
//        }
        
        .frame(maxWidth: 1000)
    }
    
    
    
    func tryHasRecordingYet()  {
        do {
            let url =  URL.documentsDirectory.appending(path: "\(recordingClass.fileName).m4a")
            hasRecordingYet = try url.checkResourceIsReachable()
            let player = try AVAudioPlayer(contentsOf : url)
            duration = player.duration
        } catch {
            hasRecordingYet = false
        }
    }
}

#Preview {
    @Previewable @State var recorderClass: RecorderClass = .init(recordingName: "newman")
    RecordingButton(recordingClass: recorderClass, /*recordingName: .constant("newRecording"),*/ isEditing: .constant(true))
}
