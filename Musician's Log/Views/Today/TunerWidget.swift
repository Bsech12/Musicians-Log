//
//  TunerWidget.swift
//  Musician's Log
//
//  Created by Bryce Sechrist on 11/20/24.
//

import SwiftUI

struct TunerWidget: View {
    var body: some View {
        VStack {
            Image(systemName: "tuningfork")
                .resizable()
                .frame(width: 50, height: 50)
            Text("\nTuner")
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
        TunerWidget()
            
    }
    .buttonBorderShape(.roundedRectangle)
    .buttonStyle(.bordered)
    .border(Color.black)
    .frame(minWidth: 200, minHeight: 200)
    .fixedSize()
    .padding(40)

}
