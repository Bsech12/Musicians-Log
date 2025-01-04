//
//  CalendarHistoryItem.swift
//  Musician's Log
//
//  Created by Bryce Sechrist on 12/16/24.
//

import SwiftUI

struct CalendarHistoryItem: View {
    @State var colors: [Color]
    @State var name: String
    @State var time1: String
    @State var time2: String
    var body: some View {
        HStack {
            HStack {
                if !colors.isEmpty {
                    ForEach(0...colors.count - 1, id: \.self) { i in
                        if (i < 4) {
                            colors[i]
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                                .frame(width: 10)
                        }
                    }
                    .padding(.leading, -10)
                    if (colors.count > 4) {
                        Text("...")
                            .padding(.leading, -5)
                            .foregroundStyle(.white)
                    }
                } else {
                    Color.gray
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .frame(width: 10)


                }
            }
            .padding(.leading)
            
            
            Text(name)
                .frame(maxWidth: .infinity)
                .lineLimit(1)
                .font(.headline)
            Spacer()
            VStack() {
                Text(time1)
                Text(time2)
            }
            .padding([.leading])
            Image(systemName: "chevron.right")
                .padding()
        }
        .background {
            
            RoundedRectangle(cornerRadius: 10)
                .fill(.quinary)
                .frame(height: 50)
                
        }
    }
}

#Preview {
    ScrollView {
        CalendarHistoryItem(colors: [.red, .green, .blue, .yellow, .purple], name: " a dsla fdsa;jfsla;fjsdlfjs;adfkla;sdkjfa;sldkfjalsdfjka;sdlfkasj;dlfja;sdlfkas;dlfjal;sdjfkal;sdfjkal;sdjfksa;shi", time1: "xx:xx", time2: "xx:xx")
        CalendarHistoryItem(colors: [.red, .green, .blue, .yellow, .purple], name: "hi", time1: "xx:xx", time2: "xx:xx")
        CalendarHistoryItem(colors: [.red, .green, .blue, .yellow, .purple], name: "hi", time1: "xx:xx", time2: "xx:xx")
        CalendarHistoryItem(colors: [.red, .green, .blue, .yellow, .purple], name: "hi", time1: "xx:xx", time2: "xx:xx")
    }
}
