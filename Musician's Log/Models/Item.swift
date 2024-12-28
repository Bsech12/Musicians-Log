//
//  Item.swift
//  Musician's Log
//
//  Created by Bryce Sechrist on 11/13/24.
//

import SwiftUI
import SwiftData

@Model
final class MusicLogStorage {
    var startTime: Date //start time
    var endTime: Date? //end time
    
    var tags: [Tag]
    
    var title: String
    var notes: String
    
    var todosCompleted: [ToDoStorage]
    
    
    init(title: String, tags: [Tag] = [], notes: String = "") {
        self.startTime = Date()
        self.tags = tags
        self.endTime = nil
        self.title = title
        self.notes = notes
        self.todosCompleted = []
    }
}

@Model
final class ToDoStorage {
    var title: String
    var notes: String
    var completed: Bool
    
    var dateCreated: Date
    var dateCompleted: Date?
    
    var tags: [Tag]
    
    init(title: String, tags: [Tag] = [], notes: String = "", completed: Bool = false) {
        self.title = title
        self.notes = notes
        self.tags = tags
        self.completed = completed
        self.dateCreated = Date()
    }
    
}

@Model
class Tag {
    var name: String
    var icon: String
    var iconType: IconType
    var color: String
    
    init(name: String, icon: String, color: Color) {
        self.name = name
        self.icon = icon
        self.color = color.rawValue
        self.iconType = .systemName
    }
    
    init(name: String, icon: String, color: Color, iconType: IconType) {
        self.name = name
        self.icon = icon
        self.color = color.rawValue
        self.iconType = iconType
    }
    
    func getColor() -> Color {
        Color(rawValue: color) ?? Color.blue
    }
    func updateColor(color: Color) {
        self.color = color.rawValue
    }
    

}

enum IconType: Codable {
    case systemName
    case emoji
}
