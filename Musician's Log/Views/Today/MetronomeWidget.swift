//
//  MetronomeWidget.swift
//  Musician's Log
//
//  Created by Bryce Sechrist on 11/20/24.
//

import SwiftUI
import SwiftTuner

struct MetronomeWidget: View {
    
    @State var metronomeSpeedText: String = "120"
    @State var metronomeSpeed: Int = 120
    @ObservedObject var metronome: MetronomeController = MetronomeController(beatsPerMinute: 100)
    var body: some View {
        VStack {
            HStack {
                Circle()
                    .fill(metronome.counter % 2 == 0 ? Color.green : Color.gray)
                    .frame(width: 20, height: 20)
                Circle()
                    .fill(metronome.counter % 2 == 1 ? Color.green : Color.gray)
                    .frame(width: 20, height: 20)
            }
            .padding()
            HStack {
                
                TextField("", text: $metronomeSpeedText)
                    .padding()
                    .keyboardType(.numberPad)
                Stepper("", value: $metronomeSpeed, in: 0...1000)
                    .onChange(of: metronomeSpeed) {
                        metronomeSpeedText = String(metronomeSpeed)
                        metronome.beatsPerMinute = metronomeSpeed
                    }
            }
            Button(metronome.isRunning ? "Stop" : "Start") {
                if metronome.isRunning {
                    metronome.stop()
                } else {
                    metronome.start()
                }
            }
            .foregroundStyle(metronome.isRunning ? .red : .accentColor)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        UIApplication.shared.endEditing()
                        if let speed = Int(metronomeSpeedText) {
                            metronomeSpeed = speed
                            metronome.beatsPerMinute = speed
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    Button {
        //As an example
        //As an example
    } label: {
        MetronomeWidget()
            
    }
    .buttonBorderShape(.roundedRectangle)
    .buttonStyle(.bordered)
    .padding(40)

}
