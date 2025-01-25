//
//  Settings.swift
//  Musician's Log
//
//  Created by Bryce Sechrist on 12/23/24.
//

import SwiftUI
import SwiftData
import SwiftTuner
import AVFAudio

struct Settings: View {
    
    @Environment(TunerConductor.self) var conductor: TunerConductor
    
    @State var showNewTag: Bool = false
    
    @Query(sort: \Tag.name) var tagTypes: [Tag]
    
    @State var tagToChange: Tag? = nil
    
    @State private var showingBufferSizeInfo: Bool = false
    @State private var showingAmplitudeThresholdInfo: Bool = false
    
    var body: some View {
        List {
            Section() {
                Text("Release Version: v" +  (Bundle.main.releaseVersionNumber ?? "e"))
                Text("Build: " + (Bundle.main.buildVersionNumber ?? "e"))
                Text("OS Version: " +  UIDevice.current.systemVersion)
            }
            Section("Tag Types") {
                FlowHStack {
                    ForEach(tagTypes) { tag in
                        TagWidget(tag: tag, onTagTapped: tagPressed, doesToggle: false)
                    }
                    
                    TagWidget(tag: Tag(name: "New Tag", icon: "plus", color: .accentColor), onTagTapped: newTagPressed, doesToggle: false)
                    
                }
                .padding()
                
                

            }
            Section("Metronome") {
                @Bindable var aConductor = conductor
                HStack {
                    Button {
                        showingBufferSizeInfo = true
                    } label: {
                        Image(systemName: "info.circle")
                    }
                    .buttonStyle(.plain)
                    .buttonBorderShape(.circle)
                    
                    Picker("Buffer Size", selection: $aConductor.bufferSize) {
                        ForEach(BufferSize.allCases, id: \.id) { bufferSize in
                            Text("\(bufferSize.rawValue)").tag(bufferSize)
                        }
                    }
                    
                }
                
                VStack { 
                    HStack {
                        Button {
                            showingAmplitudeThresholdInfo = true
                        } label: {
                            Image(systemName: "info.circle")
                        }
                        .buttonStyle(.plain)
                        .buttonBorderShape(.circle)
                        Text("Amp. Threshold: \(aConductor.amplitudeThreshold, specifier: "%0.3f")")
                        Spacer()
                    }
                    .padding(.bottom, 10)
                    
                    Slider(value: $aConductor.amplitudeThreshold, in: 0.01...0.1)
                }
                Button("Allow Microphone (Settings)") {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                }
                
            }
            Section() {
                Text("About me")
                Text("Special Thanks:")
                Text("Acknowledgements")
                
            }
            
        }
        
        .popover(isPresented: $showNewTag) {
            NewTag(tag: $tagToChange, isPresented: $showNewTag)
        }
        .navigationBarTitle("Settings")
        .alert("Buffer Size (samples)", isPresented: $showingBufferSizeInfo) {
            Button("OK", action: {})
        } message: {
            Text(String.bufferSizeInfo)
        }
        .alert("Amplitude Threshold (dB.)", isPresented: $showingAmplitudeThresholdInfo) {
            Button("OK", action: {})
        } message: {
            Text(String.amplitudeThresholdInfo)
        }
    }
    func tagPressed(tag: Tag) {
        tagToChange = tag
        showNewTag = true
    }
    
    func newTagPressed(tag: Tag) {
        tagToChange = nil
        showNewTag = true
    }
    
    
    
}


#Preview {
    NavigationView {
        Settings()
            .environment(TunerConductor())
    }
}

extension String {
    static var bufferSizeInfo: String {
        "The number of samples which will be analyzed for each update. This influences how often the pitch is read."
    }
    
    static var amplitudeThresholdInfo: String {
        "Minimum loudness for a reading to be considered. Every buffer with an amplitude below this value is ignored."
    }
}
