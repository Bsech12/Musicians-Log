//
//  TagWidget.swift
//  Musician's Log
//
//  Created by Bryce Sechrist on 12/19/24.
//

import SwiftUI

struct TagWidget: View {
    @State var tag: Tag
    @State var isGrey: Bool = false
    @State var onTagTapped: ((Tag) -> Void)?
    @State var doesToggle: Bool = true
    
    var body: some View {

            HStack {
                if tag.icon != "" {
                    if tag.iconType == .systemName {
                        Image(systemName: tag.icon)
                    } else {
                        Text(tag.icon)
                    }
                }
                Text(tag.name)
            }
            .foregroundStyle(isGrey ? .gray : tag.getColor())
            .padding(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isGrey ? .gray : tag.getColor(), lineWidth: 2)
            )
            .frame(maxHeight: 20)
            .onTapGesture {
                if doesToggle{
                    isGrey.toggle()
                }
                onTagTapped?(tag)
            }
        }
    
}

#Preview {
    TagWidget(tag: Tag(name: "Violin", icon: "🎻", color: .blue, iconType: .emoji), isGrey: true) { a in
        return
    }

}
