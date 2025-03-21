//
//  TunerWidget.swift
//  Musician's Log
//
//  Created by Bryce Sechrist on 11/20/24.
//

import SwiftUI
import SwiftTuner

struct TunerWidget: View {
    @Environment(TunerConductor.self) var conductor: TunerConductor
    @Binding var hasPermission: Bool

    var body: some View {
        VStack {
            Text("Tuner")
                .font(.headline)
                .foregroundStyle(.primary)
                .padding(.top)
            
            ZStack {
                TunerMainView(tuner: conductor)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .tint(hasPermission ? Color.blue: Color.secondary)
                    .grayscale(hasPermission ? 0 : 1)
                    .ignoresSafeArea(edges: .all)
                    .frame(minWidth: 300, maxWidth: 300, minHeight: 300, maxHeight: 300)
                if !hasPermission {
                    Button
                    {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.secondary)
                                .padding()
                                .opacity(0.8)
                            Text("To use the tuner, please allow access to your microphone.")
                                .font(.title)
                        }
                    }
                }
            }
            .onAppear {
                conductor.start()
            }
        }
    }
}

#Preview {
    TunerWidget(hasPermission: .constant(true))
        .environment(TunerConductor(isMockingInput: true))
}
