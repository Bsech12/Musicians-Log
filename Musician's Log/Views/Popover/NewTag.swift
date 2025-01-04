//
//  NewTag.swift
//  Musician's Log
//
//  Created by Bryce Sechrist on 12/23/24.
//

import SwiftUI

struct NewTag: View {
    @Binding var tag: Tag?
    @State var isNew: Bool = true
    @Binding var isPresented: Bool
    @State var name: String = ""
    @State var icon: String = "" //TODO: Make a list of icons!
    @State var color: Color = Color.red
    
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        VStack {
            Text("New Tag")
                .padding()
                .font(.headline)
                .frame(maxWidth: .infinity)
            
            Form {
                Section {
                    TextField("Name", text: $name)
                    
                    TextField("Icon", text: $icon)
                    
                    ColorPicker("Color", selection: $color)
                }
                Section {
                    Button(isNew ? "Create Tag" : "Update Tag") {
                        if isNew {
                            let newTag = Tag(name: name, icon: icon, color: color)
                            modelContext.insert(newTag)
                            try? modelContext.save()
                            isPresented = false
                        } else {
                            if let tag {
                                tag.name = name
                                tag.icon = icon
                                tag.updateColor(color: color)
                                isPresented = false
                            }
                        }
                        
                    }
                }
            }
            .onAppear() {
                if let tag {
                    isNew = false
                    name = tag.name
                    icon = tag.icon
                    color = tag.getColor()
                }
            }
        }
        .background(Color.listGrey)
        
    }
}

#Preview {
    @Previewable @State var isPresented: Bool = false
    @Previewable @State var tag: Tag? = Tag(name: "Test Tag", icon: "", color: Color.red)
    NewTag(tag: $tag, isPresented: $isPresented)
}
