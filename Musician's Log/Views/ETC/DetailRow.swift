//
//  DetailRow.swift
//  Musician's Log
//
//  Created by Bryce Sechrist on 12/25/24.
//

import SwiftUI

struct DetailRow: View {
    @Binding var leftText: String
    @Binding var rightText: String
    
    init(_ leftText: String, _ rightText: String = "") {
        self._leftText = .constant(leftText)
        self._rightText = .constant(rightText)
    }
    init(_ leftText: Binding<String>, _ rightText: Binding<String> = .constant("")) {
        self._leftText = leftText
        self._rightText = rightText
    }
    init(_ leftText: String, _ rightText: Binding<String> = .constant("")) {
        self._leftText = .constant(leftText)
        self._rightText = rightText
    }
    
//        init(_ leftText: String, _ rightText: String = "") {
//            self.leftText = leftText
//            self.rightText = rightText
//        }
//    
    var body: some View {
        HStack
        {
            Text(leftText)
            Spacer()
            Text(rightText)
        }
    }
}

#Preview {
    List {
        DetailRow("Hi", "There")
        DetailRow("Hello", "World")
    }
}
