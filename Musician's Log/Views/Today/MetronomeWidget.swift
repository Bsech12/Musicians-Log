//
//  MetronomeWidget.swift
//  Musician's Log
//
//  Created by Bryce Sechrist on 11/20/24.
//

import SwiftUI

struct MetronomeWidget: View {
    var body: some View {
        VStack {
            Image(systemName: "metronome")
                .resizable()
                .frame(width: 50, height: 50)
            Text("\nMetronome")
                .font(.title2)
                .frame(maxWidth: .infinity, alignment: .center)
        }
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
