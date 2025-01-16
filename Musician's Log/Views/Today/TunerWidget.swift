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
    var body: some View {
        TunerRootView(tuner: conductor)
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
        TunerWidget()
            .environment(TunerConductor(isMockingInput: true))
            
    }
    .buttonBorderShape(.roundedRectangle)
    .buttonStyle(.bordered)
    .border(Color.black)
    .frame(minWidth: 200, minHeight: 200)
    .fixedSize()
    .padding(40)

}
