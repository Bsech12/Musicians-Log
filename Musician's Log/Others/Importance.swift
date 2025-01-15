//
//  Importance.swift
//  Musician's Log
//
//  Created by Bryce Sechrist on 11/22/24.
//

import SwiftUI

enum Importance: Codable, CustomStringConvertible {
    case low, medium, high, veryHigh, none
    
    func toColor() -> Color {
        switch self {
        case .low: return .blue
        case .medium: return .yellow
        case .high: return .orange
        case .veryHigh: return .red
        case .none: return .primary
        }
    }
    var description: String {
        switch self {
        case .low: return "Low"
        case .medium: return "Medium"
        case .high: return "High"
        case .veryHigh: return "Very High"
        case .none: return "None"
        }
    }
}

