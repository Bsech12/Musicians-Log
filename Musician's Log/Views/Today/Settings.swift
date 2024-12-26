//
//  Settings.swift
//  Musician's Log
//
//  Created by Bryce Sechrist on 12/23/24.
//

import SwiftUI
import SwiftData

struct Settings: View {
    
    @State var showNewTag: Bool = false
    
    @Query(sort: \Tag.name) var tagTypes: [Tag]
    
    @State var tagToChange: Tag? = nil
    
    var body: some View {
        List {
            Section("Tag Types") {
                FlowHStack {
                    ForEach(tagTypes) { tag in
                        TagWidget(tag: tag, onTagTapped: tagPressed, doesToggle: false)
                    }
                    
                    TagWidget(tag: Tag(name: "New Tag", icon: "plus", color: .accentColor), onTagTapped: newTagPressed, doesToggle: false)
                    
                }
                .padding()
                
                

            }
            
        }
        
        .popover(isPresented: $showNewTag) {
            NewTag(tag: $tagToChange, isPresented: $showNewTag)
        }
        .navigationBarTitle("Settings")
    }
    func tagPressed(tag: Tag) {
        tagToChange = tag
        showNewTag = true
    }
    
    func newTagPressed(tag: Tag) {
        tagToChange = nil
        showNewTag = true
    }
    
    
    
}


#Preview {
    NavigationView {
        Settings()
    }
}
