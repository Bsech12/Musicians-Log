//
//  TunerPopover.swift
//  Musician's Log
//
//  Created by Bryce Sechrist on 1/19/25.
//

import SwiftUI
import SwiftTuner

struct TunerPopover: View {
    @Binding var tuner: TunerConductor
    var body: some View {
        TunerWidget(hasPermission: true)
            .environment(tuner)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    TunerPopover(tuner: .constant(.init()))
}
