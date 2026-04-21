import Foundation

// MARK: - Pet Type

enum PetType: String, Codable, CaseIterable {
    case cat, dog, rabbit
    
    var icon: String {
        switch self {
        case .cat: return "cat.fill"
        case .dog: return "dog.fill"
        case .rabbit: return "hare.fill"
        }
    }
    
    var displayEmoji: String {
        switch self {
        case .cat: return "🐱"
        case .dog: return "🐶"
        case .rabbit: return "🐰"
        }
    }
}

// MARK: - Mood

enum Mood: String, Codable, CaseIterable {
    case happy, calm, sad, anxious
    
    var label: String {
        switch self {
        case .happy: return "开心"
        case .calm: return "平静"
        case .sad: return "低落"
        case .anxious: return "焦虑"
        }
    }
    
    var emoji: String {
        switch self {
        case .happy: return "✨"
        case .calm: return "🌿"
        case .sad: return "🌧️"
        case .anxious: return "🌪️"
        }
    }
    
    var moodEmoji: String? {
        switch self {
        case .sad: return "💧"
        case .anxious: return "〰️"
        case .happy: return "✨"
        case .calm: return nil
        }
    }
}

// MARK: - Chat Message

struct ChatMessage: Codable, Identifiable, Equatable {
    let id: UUID
    let role: ChatRole
    let text: String
    
    init(role: ChatRole, text: String) {
        self.id = UUID()
        self.role = role
        self.text = text
    }
}

enum ChatRole: String, Codable {
    case user, model
}

// MARK: - Pet State

struct PetState: Codable, Equatable {
    var hasOnboarded: Bool = false
    var petType: PetType = .cat
    var petName: String = "小可爱"
    var mood: Mood = .calm
    var interactionCount: Int = 0
    var lastInteractionDate: String = ""
}

// MARK: - Breathing Phase

enum BreathePhase: String {
    case breatheIn = "吸气..."
    case hold = "屏息..."
    case breatheOut = "呼气..."
}
