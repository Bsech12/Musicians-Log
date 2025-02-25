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
            Text("Metronome")
                .font(.headline)
                .foregroundStyle(.primary)
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
                    .keyboardType(.numberPad)
                    .overlay(RoundedRectangle(cornerRadius: 5)
                        .stroke(style: StrokeStyle(lineWidth: 1))
                             , alignment: .leading)
                    .padding()
                Stepper("", value: $metronomeSpeed, in: 0...1000)
                    .onChange(of: metronomeSpeed) {
                        metronomeSpeedText = String(metronomeSpeed)
                        metronome.beatsPerMinute = metronomeSpeed
                    }
                    .frame(maxWidth: 100)
                    .padding()
            }
            Button(metronome.isRunning ? "Stop" : "Start") {
                if metronome.isRunning {
                    metronome.stop()
                } else {
                    metronome.start()
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(metronome.isRunning ? .red : .accentColor)
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
    MetronomeWidget()
}
