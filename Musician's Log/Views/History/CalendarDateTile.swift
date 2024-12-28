//
//  CalendarDateTile.swift
//  Musician's Log
//
//  Created by Bryce Sechrist on 12/14/24.
//

import SwiftUI

struct CalendarDateTile: View {
    @State var number: Int
    @State var borderWidth: Float
    @Binding var calTileStle: CalTileStyle
    @Binding var selected: Int
    @Binding var colors: [Color]
    
    //TODO: add when was practiced!!
    
    var body: some View {
        let today = (calTileStle == .today && number == Date().dayInt)
        Button {
            if number != 0 {
                selected = number
            }
        } label: {
            VStack {
                ZStack {
                    if(selected == number) {
                        Circle()
                            .foregroundStyle(today ? .red : .secondary)
                            .frame(width: 40)
                    }
                    Text(number == 0 ? "" : String(number))
                        .foregroundStyle(today ? (selected == number ? .white : .red) : .primary)
                        .frame(maxWidth: .infinity)
                        .bold(calTileStle == .today)
                        .padding()
                }
        
                HStack(spacing: -3) {
                    if colors.isEmpty {
                        Circle()
                            .frame(height: 9)
                            .foregroundStyle(.clear)
                    } else {
                        ForEach(0...colors.count - 1, id: \.self) { i in
                            if (i < 4) {
                                
                                colors[i]
                                    .clipShape(Circle())
                                    .frame(width: 9, height: 9)
                            }
                        }
                    }
                    if colors.count > 4 {
                        Text(" ...")
                    }


                }

            }
            .border(Color.primary, width: CGFloat(borderWidth))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    LazyHStack {
        CalendarDateTile(number: 16, borderWidth: 1, calTileStle: .constant(.today), selected: .constant(16), colors: .constant([.red, .blue,.green, .orange, .yellow, .pink, .yellow]))
    }
}

enum CalTileStyle {
   case normal,
    grey,
    today
}
