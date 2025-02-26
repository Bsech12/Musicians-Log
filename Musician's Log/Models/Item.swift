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
    
    var recordings: [String] = []
    
    var todosCompleted: [ToDoStorage]
    
    func getColors() -> [Color] {
        var colors: [Color] = []
        for tag in tags {
            colors.append(tag.getColor())
        }
        return colors
    }
    
    init(title: String, startTime: Date = Date(), endTime: Date? = nil, tags: [Tag] = [], notes: String = "", todosCompleted: [ToDoStorage] = []) {
        self.startTime = startTime
        self.tags = tags
        self.endTime = endTime
        self.title = title
        self.notes = notes
        self.todosCompleted = []
        self.recordings = []
    }
}

@Model
final class ToDoStorage {
    var title: String
    var notes: String
    var importance: Importance
    var dueDate: Date?
    var reminderDate: Date?
    var completed: Bool {
        didSet {
            print("worked?")
            self.dateCompleted = Date()
            print(self)
        }
    }
    
    var dateCreated: Date
    var dateCompleted: Date?
    
    var tags: [Tag]
    
    init(title: String, tags: [Tag] = [], notes: String = "", importance: Importance = .low, completed: Bool = false, dueDate: Date? = nil, reminderDate: Date? = nil) {
        self.title = title
        self.notes = notes
        self.importance = importance
        self.tags = tags
        self.completed = completed
        self.dateCreated = Date()
        self.reminderDate = reminderDate
        self.dueDate = dueDate
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
