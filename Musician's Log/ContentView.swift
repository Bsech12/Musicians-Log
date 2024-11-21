//
//  ContentView.swift
//  Musician's Log
//
//  Created by Bryce Sechrist on 11/13/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
//    @Environment(\.modelContext) private var modelContext
//    @Query private var items: [Item]
    @State var tabSelected = 1
    
    var body: some View {
        TabView(selection: $tabSelected) {
            Tab("History", systemImage: "book", value: 0) {
                Text("History")
            }
            Tab("Today", systemImage: "music.note.house.fill", value: 1) {
                Today()
            }
            Tab("Todo", systemImage: "checklist.unchecked", value: 2) {
                Text("Todo")
            }
            
        }
    }
}

#Preview {
    ContentView()
//        .modelContainer(for: Item.self, inMemory: true)
}
