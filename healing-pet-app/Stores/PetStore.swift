import Foundation
import Combine

class PetStore: ObservableObject {
    @Published var state: PetState = PetState()
    @Published var chatHistory: [ChatMessage] = []
    @Published var dialogue: String = ""
    @Published var isTyping: Bool = false
    
    private let storageKey = "pet_state"
    private var cancellables = Set<AnyCancellable>()
    
    static let petQuotes = [
        "我在这里呀，放心。",
        "(*轻轻蹭了蹭你的手*)",
        "今天也要好好的哦！",
        "如果你累了，就靠在我身上吧。",
        "(*摇尾巴*)",
        "我会一直陪伴着你。",
        "(*深情地望着你*)"
    ]
    
    // Local pet responses based on mood (fallback for no API)
    static let moodResponses: [Mood: [String]] = [
        .happy: [
            "(*开心地转圈*) 你笑起来真好看！",
            "(*摇尾巴*) 今天心情真好呀！",
            "(*蹦蹦跳跳*) 和你在一起好开心！"
        ],
        .calm: [
            "(*安静地趴在你身边*) 好舒服呀。",
            "(*轻轻打了个哈欠*) 这样静静的也很好。",
            "(*温柔地看着你*) 平静的时光最珍贵。"
        ],
        .sad: [
            "(*安静地依偎在你身边*) 我一直在这里。",
            "(*轻轻蹭你的手*) 不开心也没关系。",
            "(*用头轻轻顶你*) 让我陪陪你吧。"
        ],
        .anxious: [
            "(*安静地陪伴着你*) 深呼吸，我在。",
            "(*温柔地看着你*) 没事的，一切都会好的。",
            "(*轻轻握住你的手*) 别害怕，我陪着你。"
        ]
    ]
    
    init() {
        loadState()
        
        $state
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] newState in
                self?.saveState(newState)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Today
    
    private var todayStr: String {
        Date().formatted(.dateTime.year().month().day())
    }
    
    // MARK: - Actions
    
    func startOnboarding() {
        guard !state.petName.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        state.hasOnboarded = true
        let welcome = "你好！我是\(state.petName)！我会一直陪着你的。"
        dialogue = welcome
        chatHistory = [ChatMessage(role: .model, text: welcome)]
    }
    
    func cyclePetType() {
        let types = PetType.allCases
        if let idx = types.firstIndex(of: state.petType) {
            state.petType = types[(idx + 1) % types.count]
        }
    }
    
    func setMood(_ mood: Mood) {
        state.mood = mood
    }
    
    func incrementInteraction() {
        let today = todayStr
        if state.lastInteractionDate != today {
            state.interactionCount = 1
            state.lastInteractionDate = today
        } else {
            state.interactionCount += 1
        }
    }
    
    func handlePetAction() {
        incrementInteraction()
        let quote = Self.petQuotes.randomElement() ?? "(*摇尾巴*)"
        dialogue = quote
        chatHistory.append(ChatMessage(role: .model, text: quote))
    }
    
    func sendChat(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty, !isTyping else { return }
        
        incrementInteraction()
        chatHistory.append(ChatMessage(role: .user, text: trimmed))
        isTyping = true
        
        // Simulate AI response (local fallback)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            let responses = Self.moodResponses[self.state.mood] ?? Self.petQuotes
            let response = responses.randomElement() ?? "(*安静地陪伴着你*)"
            self.chatHistory.append(ChatMessage(role: .model, text: response))
            self.dialogue = response
            self.isTyping = false
        }
    }
    
    func finishBreathing() {
        let msg = "你做得很棒，感觉好些了吗？"
        dialogue = msg
        chatHistory.append(ChatMessage(role: .model, text: msg))
    }
    
    func showInitialGreeting() {
        guard state.hasOnboarded, dialogue.isEmpty, chatHistory.isEmpty else { return }
        let welcome: String
        if state.mood == .sad || state.mood == .anxious {
            welcome = "(*安静地陪在\(state.petName)身边*)"
        } else {
            welcome = "今天过得怎么样？"
        }
        dialogue = welcome
        chatHistory = [ChatMessage(role: .model, text: welcome)]
    }
    
    // MARK: - Persistence
    
    private func loadState() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode(PetState.self, from: data) {
            var loaded = decoded
            // Reset interaction count if new day
            if loaded.lastInteractionDate != todayStr {
                loaded.interactionCount = 0
                loaded.lastInteractionDate = todayStr
            }
            self.state = loaded
        }
    }
    
    private func saveState(_ state: PetState) {
        if let encoded = try? JSONEncoder().encode(state) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
}
