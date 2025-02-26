//
//  Extra.swift
//  Musician's Log
//
//  Created by Bryce Sechrist on 11/21/24.
//

import SwiftUI

extension Color {

    static var listGrey: Color {
        return Color(UIColor.systemGroupedBackground)
    }
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
extension Date {
    var weekday: Int { Calendar.current.component(.weekday, from: self) }
    var firstDayOfTheMonth: Date {
        Calendar.current.dateComponents([.calendar, .year,.month], from: self).date!
    }
    
    var firstDayOfTheWeek: Date {
        Calendar.current.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: self).date!
    }
    var monthString: String {
        if let monthInt = Calendar.current.dateComponents([.month], from: self).month {
            return Calendar.current.monthSymbols[monthInt-1]
        }
        return ""
    }
    var monthInt: Int {
        if let monthInt = Calendar.current.dateComponents([.month], from: self).month {
            return monthInt
        }
        return 0
    }
    var yearString: String {
        if let year = Calendar.current.dateComponents([.year], from: self).year {
            return "\(year)"
        }
        return ""
    }
    var yearInt: Int {
        if let year = Calendar.current.dateComponents([.year], from: self).year {
            return year
        }
        return 0
    }
    var dayInt: Int {
        if let day = Calendar.current.dateComponents([.day], from: self).day {
            return day
        }
        return 0
    }
    func differenceBetween(dateToUse: Date) -> DateComponents{
        let diffs = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self, to: dateToUse)
        return diffs
    }
    func basicallyTheSameAs(_ dateToUse: Date) -> Bool {
        return yearString == dateToUse.yearString && monthInt == dateToUse.monthInt && dayInt == dateToUse.dayInt
    }
    
}

extension View {
    func swipe(
        up: @escaping (() -> Void) = {},
        down: @escaping (() -> Void) = {},
        left: @escaping (() -> Void) = {},
        right: @escaping (() -> Void) = {},
        valueChanged: @escaping ((DragGesture.Value) -> Void) = {_ in }
    ) -> some View {
        return self.gesture(DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onEnded({ value in
                if value.translation.width < 0 { left() }
                if value.translation.width > 0 { right() }
                if value.translation.height < 0 { up() }
                if value.translation.height > 0 { down() }
            })
            .onChanged({ value in
                valueChanged(value)
            })
        )
    }
}

extension Color: @retroactive RawRepresentable {

    public init?(rawValue: String) {
        
        guard let data = Data(base64Encoded: rawValue) else{
            self = .black
            return
        }
        
        do{
            let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data) ?? .black
            self = Color(color)
        }catch{
            self = .black
        }
        
    }

    public var rawValue: String {
        
        do{
            let data = try NSKeyedArchiver.archivedData(withRootObject: UIColor(self), requiringSecureCoding: false) as Data
            return data.base64EncodedString()
            
        }catch{
            
            return ""
            
        }
        
    }

}

extension Bundle {
    var icon: UIImage? {
      
      if let icons = infoDictionary?["CFBundleIcons"] as? [String: Any],
         let primary = icons["CFBundlePrimaryIcon"] as? [String: Any],
         let files = primary["CFBundleIconFiles"] as? [String],
         let icon = files.last
      {
        return UIImage(named: icon)
      }
      
      return nil
    }
  
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension Double {
    
    func secondsToHoursMinutesSeconds(seconds: Double) -> (Double, Double, Double) {
      let (hr,  minf) = modf(seconds / 3600)
      let (min, secf) = modf(60 * minf)
      return (hr, min, 60 * secf)
    }
    
    func rounded(_ places:Int) -> String {
        return String(format: "%.\(places)f", self)
    }
    
    func toHMS() -> String{
        let (h, m, s) = secondsToHoursMinutesSeconds(seconds: self)
        if(h > 0) {
            return ("\(h.rounded(0)):\(m.rounded(0)):\(s.rounded(2))")
        } else {
            return("\(m.rounded(0)):\(s.rounded(2))")
        }
    }
}

