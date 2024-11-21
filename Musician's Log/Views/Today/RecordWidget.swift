//
//  RecordWidget.swift
//  Musician's Log
//
//  Created by Bryce Sechrist on 11/18/24.
//

import SwiftUI

struct RecordWidget: View {
    var body: some View {
        HStack {
            VStack {
                Text("Record")
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Today: 00:00:00")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            Image(systemName: "record.circle")
                .scaledToFit()
                .foregroundStyle(.red)
        }
        .padding()
        

        
    }
}

#Preview {
    Button {
        //As an example
    } label: {
        RecordWidget()
            
    }
    .buttonBorderShape(.roundedRectangle)
    .buttonStyle(.bordered)
    .padding(40)

}
