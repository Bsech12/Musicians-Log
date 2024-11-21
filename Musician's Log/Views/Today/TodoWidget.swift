//
//  TodoWidget.swift
//  Musician's Log
//
//  Created by Bryce Sechrist on 11/21/24.
//

import SwiftUI

struct TodoWidget: View {
    var body: some View {
        VStack {
            Text("Todo:")
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            VStack {
                TodoItem(name: "This is something I need to do!", checked: true )
                    .frame(maxWidth: .infinity, alignment: .leading)
                TodoItem(name: "asdfasdf", checked: false )
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
        }
    }
}

#Preview {
    TodoWidget()
        .padding(40)
        .border(.gray)
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 25, height: 25)))
        .frame(minWidth: 300, minHeight: 300)
}
