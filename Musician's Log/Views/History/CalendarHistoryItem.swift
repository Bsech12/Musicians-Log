//
//  CalendarHistoryItem.swift
//  Musician's Log
//
//  Created by Bryce Sechrist on 12/16/24.
//

import SwiftUI

struct CalendarHistoryItem: View {
    @State var color: Color = .red
    @State var name: String = "Calendar History Item"
    @State var time1: String = "12:00 PM"
    @State var time2: String = "4:00 PM"
    var body: some View {
        HStack {
            Text(" ")
                .border(color, width: 4)
                .padding()
            Spacer()
            Text(name)
                .font(.headline)
            Spacer()
            VStack() {
                Text(time1)
                Text(time2)
            }
            .padding()
        }
    }
}

#Preview {
    CalendarHistoryItem()
}
