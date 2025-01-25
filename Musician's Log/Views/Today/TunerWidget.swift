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
    @State var hasPermission: Bool

    var body: some View {
        ZStack {
            TunerRootView(tuner: conductor)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .tint(hasPermission ? Color.blue: Color.secondary)
                .grayscale(hasPermission ? 0 : 1)
            
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
    }
}

#Preview {
    Button {
        //As an example
        //As an example
    } label: {
        TunerWidget(hasPermission: false)
            .environment(TunerConductor(isMockingInput: true))
            
    }
    .buttonBorderShape(.roundedRectangle)
    .buttonStyle(.bordered)
    .border(Color.black)
    .frame(minWidth: 200, minHeight: 200)
    .fixedSize()
    .padding(40)

}
