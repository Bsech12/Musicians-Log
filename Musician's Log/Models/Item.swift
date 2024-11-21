//
//  Item.swift
//  Musician's Log
//
//  Created by Bryce Sechrist on 11/13/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    var endDate: Date?
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
