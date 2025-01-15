//
//  TagWidget.swift
//  Musician's Log
//
//  Created by Bryce Sechrist on 12/19/24.
//

import SwiftUI

struct TagWidget: View {
    @State var tag: Tag
    @State var smaller: Bool = false
    @State var isGrey: Bool = false
    @State var onTagTapped: ((Tag) -> Void)?
    @State var doesToggle: Bool = true
    
    var body: some View {

            HStack {
                if tag.icon != "" {
                    if tag.iconType == .systemName {
                        Image(systemName: tag.icon)
                            .frame(maxHeight: 20)
                    } else {
                        Text(tag.icon)
                            .font(smaller ? .caption : .title3)
                    }
                }
                Text(tag.name)
                    .font(smaller ? .caption : .title3)
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
    .padding()
    TagWidget(tag: Tag(name: "Violin", icon: "plus", color: .blue, iconType: .systemName), isGrey: true)
}
