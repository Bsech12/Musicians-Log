//
//  CalendarDateTile.swift
//  Musician's Log
//
//  Created by Bryce Sechrist on 12/14/24.
//

import SwiftUI

struct CalendarDateTile: View {
    @State var number: String
    @State var borderWidth: Float
    @Binding var calTileStle: CalTileStyle
    @Binding var selected: String
    //TODO: add when was practiced!!
    
    var body: some View {
        let today = (calTileStle == .today && number == "\(Date().dayInt)")
        Button {
            selected = number
        } label: {
            VStack {
                ZStack {
                    if(selected == number) {
                        Circle()
                            .foregroundStyle(today ? .red : .secondary)
                            .frame(width: 40)
                    }
                    Text(number)
                        .foregroundStyle(today ? (selected == number ? .white : .red) : .primary)
                        .frame(maxWidth: .infinity)
                        .bold(calTileStle == .today)
                        .padding()
                }
                Text("")
            }
            .border(Color.primary, width: CGFloat(borderWidth))
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    LazyHStack {
        CalendarDateTile(number: "16", borderWidth: 1, calTileStle: .constant(.today), selected: .constant("16"))
    }
}

enum CalTileStyle {
   case normal,
    grey,
    today
}
