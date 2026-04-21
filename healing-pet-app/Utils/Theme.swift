import SwiftUI
import UIKit

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r)/255, green: Double(g)/255, blue: Double(b)/255, opacity: Double(a)/255)
    }
    
    // Duolingo brand colors
    static var duoGreen: Color { Color(hex: "58cc02") }
    static var duoGreenDark: Color { Color(hex: "58a700") }
    static var duoBlue: Color { Color(hex: "1cb0f6") }
    static var duoBlueDark: Color { Color(hex: "1899d6") }
    static var duoOrange: Color { Color(hex: "ff9600") }
    static var duoOrangeDark: Color { Color(hex: "cc7b00") }
    static var duoYellow: Color { Color(hex: "ffc800") }
    static var duoYellowDark: Color { Color(hex: "cca000") }
    static var duoPurple: Color { Color(hex: "ce82ff") }
    static var duoPurpleDark: Color { Color(hex: "a568cc") }
    static var duoRed: Color { Color(hex: "ff4b4b") }
    
    // Adaptive semantic
    static var appBg: Color { Color(UIColor { $0.userInterfaceStyle == .dark ? UIColor(Color(hex: "131f24")) : .white }) }
    static var appSurface: Color { Color(UIColor { $0.userInterfaceStyle == .dark ? UIColor(Color(hex: "202f36")) : .white }) }
    static var appText: Color { Color(UIColor { $0.userInterfaceStyle == .dark ? .white : UIColor(Color(hex: "4b4b4b")) }) }
    static var appTextMuted: Color { Color(UIColor { $0.userInterfaceStyle == .dark ? UIColor(Color(hex: "77858c")) : UIColor(Color(hex: "afafaf")) }) }
    static var appBorder: Color { Color(UIColor { $0.userInterfaceStyle == .dark ? UIColor(Color(hex: "37464f")) : UIColor(Color(hex: "e5e5e5")) }) }
    static var appBorderDark: Color { Color(UIColor { $0.userInterfaceStyle == .dark ? UIColor(Color(hex: "2a3840")) : UIColor(Color(hex: "d5d5d5")) }) }
    
    // Mood colors
    func moodColor(for mood: Mood) -> Color {
        switch mood {
        case .happy: return .duoYellow
        case .calm: return .duoGreen
        case .sad: return .duoBlue
        case .anxious: return .duoPurple
        }
    }
}

extension Color {
    static func petColor(for type: PetType) -> Color {
        switch type {
        case .cat: return .duoOrange
        case .dog: return .duoYellowDark
        case .rabbit: return .duoPurple
        }
    }
}
