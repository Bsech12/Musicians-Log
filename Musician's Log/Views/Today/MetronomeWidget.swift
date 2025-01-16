//
//  MetronomeWidget.swift
//  Musician's Log
//
//  Created by Bryce Sechrist on 11/20/24.
//

import SwiftUI
import SwiftTuner

struct MetronomeWidget: View {
    var body: some View {
        TunerRootView(tuner: TunerConductor())
        .padding()
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity

        )
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
