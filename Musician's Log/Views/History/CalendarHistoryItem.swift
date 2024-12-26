//
//  CalendarHistoryItem.swift
//  Musician's Log
//
//  Created by Bryce Sechrist on 12/16/24.
//

import SwiftUI

struct CalendarHistoryItem: View {
    @State var color: Color
    @State var name: String
    @State var time1: String
    @State var time2: String
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
    CalendarHistoryItem(color: .red, name: "hi", time1: "xx:xx", time2: "xx:xx")
}
