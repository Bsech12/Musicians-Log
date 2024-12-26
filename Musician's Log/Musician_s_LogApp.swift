//
//  Musician_s_LogApp.swift
//  Musician's Log
//
//  Created by Bryce Sechrist on 11/13/24.
//

import SwiftUI
import SwiftData

@main
struct Musician_s_LogApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            MusicLogStorage.self, ToDoStorage.self, Tag.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
