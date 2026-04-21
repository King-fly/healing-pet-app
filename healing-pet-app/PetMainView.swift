import SwiftUI

struct PetMainView: View {
    @EnvironmentObject var store: PetStore
    @State private var activeTab: ActiveTab = .idle
    @State private var breathePhase: BreathePhase = .breatheIn
    @State private var breatheCount = 0
    @State private var chatInput = ""
    @State private var petBounce = false
    
    enum ActiveTab {
        case idle, chat, breathe
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            headerBar
            
            // Main content
            ZStack {
                Color.appBg.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Pet display area
                    petDisplayArea
                    
                    // Chat list (only when chat active)
                    if activeTab == .chat {
                        chatListView
                    }
                }
            }
            
            // Footer
            footerBar
        }
        .background(Color.appBg.ignoresSafeArea())
        .onAppear { store.showInitialGreeting() }
    }
    
    // MARK: - Header
    
    private var headerBar: some View {
        HStack {
            // Mood buttons
            HStack(spacing: 8) {
                ForEach(Mood.allCases, id: \.self) { mood in
                    Button {
                        store.setMood(mood)
                    } label: {
                        Text(mood.emoji)
                            .font(.system(size: 20))
                            .frame(width: 40, height: 40)
                            .background(store.state.mood == mood ? Color.appBg : Color.clear)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(store.state.mood == mood ? Color.appBorder : Color.clear, lineWidth: 2)
                            )
                            .scaleEffect(store.state.mood == mood ? 1.1 : 1.0)
                            .opacity(store.state.mood == mood ? 1.0 : 0.5)
                            .grayscale(store.state.mood == mood ? 0 : 0.8)
                    }
                    .animation(.spring(response: 0.3), value: store.state.mood)
                }
            }
            
            Spacer()
            
            // Interaction count
            HStack(spacing: 4) {
                Text("互动")
                    .font(.system(size: 14, weight: .black))
                    .foregroundColor(.appTextMuted)
                Text("\(store.state.interactionCount)")
                    .font(.system(size: 14, weight: .black))
                    .foregroundColor(.duoOrangeDark)
                    .frame(width: 28, height: 28)
                    .background(Color.duoOrange.opacity(0.2))
                    .cornerRadius(14)
                    .overlay(Circle().stroke(Color.duoOrange, lineWidth: 2))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.appSurface)
        .overlay(Rectangle().frame(height: 2).foregroundColor(.appBorder), alignment: .bottom)
    }
    
    // MARK: - Pet Display
    
    private var petDisplayArea: some View {
        let isCompact = activeTab == .chat
        
        return VStack {
            Spacer()
            
            ZStack {
                // Breathing ambient
                if activeTab == .breathe {
                    Circle()
                        .fill(Color.duoGreen)
                        .frame(width: 200, height: 200)
                        .blur(radius: 60)
                        .opacity(breathePhase == .breatheIn ? 0.4 : breathePhase == .breatheOut ? 0.1 : 0.4)
                        .scaleEffect(breathePhase == .breatheIn ? 1.5 : breathePhase == .breatheOut ? 0.8 : 1.5)
                        .animation(.easeInOut(duration: breathePhase == .hold ? 2 : 4), value: breathePhase)
                }
                
                // Pet icon
                VStack(spacing: 0) {
                    ZStack {
                        RoundedRectangle(cornerRadius: isCompact ? 24 : 40)
                            .fill(Color.appSurface)
                            .frame(width: isCompact ? 80 : 140, height: isCompact ? 80 : 140)
                            .overlay(
                                RoundedRectangle(cornerRadius: isCompact ? 24 : 40)
                                    .stroke(Color.appBg, lineWidth: 6)
                            )
                            .shadow(color: .black.opacity(0.1), radius: 12, y: 6)
                        
                        Image(systemName: store.state.petType.icon)
                            .font(.system(size: isCompact ? 36 : 64, weight: .medium))
                            .foregroundColor(Color.petColor(for: store.state.petType))
                        
                        // Mood indicator
                        if let moodEmoji = store.state.mood.moodEmoji {
                            Text(moodEmoji)
                                .font(.system(size: 18))
                                .offset(x: isCompact ? 28 : 48, y: isCompact ? -28 : -48)
                                .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: petBounce)
                        }
                    }
                    .offset(y: petBounce ? -5 : 0)
                    .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: petBounce)
                    .onAppear { petBounce = true }
                }
            }
            
            // Breathe indicator
            if activeTab == .breathe {
                Text(breathePhase.rawValue)
                    .font(.system(size: 20, weight: .black))
                    .foregroundColor(.duoGreenDark)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 8)
                    .background(Color.appSurface)
                    .cornerRadius(20)
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.appBorder, lineWidth: 2))
                    .padding(.top, 16)
            }
            
            // Dialogue bubble (idle only)
            if activeTab == .idle, !store.dialogue.isEmpty {
                VStack(spacing: 0) {
                    // Triangle
                    Triangle()
                        .fill(Color.appBorder)
                        .frame(width: 24, height: 12)
                    
                    Text(store.dialogue)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.appText)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(16)
                        .background(Color.appSurface)
                        .cornerRadius(20)
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.appBorder, lineWidth: 2))
                }
                .padding(.horizontal, 40)
                .padding(.top, 8)
                .transition(.opacity.combined(with: .scale(scale: 0.9)))
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(height: isCompact ? 150 : nil)
        .clipped()
    }
    
    // MARK: - Chat List
    
    private var chatListView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(store.chatHistory) { msg in
                        HStack {
                            if msg.role == .user { Spacer() }
                            
                            Text(msg.text)
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(msg.role == .user ? .white : .appText)
                                .padding(12)
                                .background(msg.role == .user ? Color.duoBlue : Color.appSurface)
                                .cornerRadius(16)
                                .overlay(
                                    msg.role == .model ?
                                        RoundedRectangle(cornerRadius: 16).stroke(Color.appBorder, lineWidth: 2)
                                    : nil
                                )
                                .frame(maxWidth: UIScreen.main.bounds.width * 0.75, alignment: msg.role == .user ? .trailing : .leading)
                            
                            if msg.role == .model { Spacer() }
                        }
                        .id(msg.id)
                    }
                    
                    // Typing indicator
                    if store.isTyping {
                        HStack {
                            HStack(spacing: 6) {
                                ForEach(0..<3, id: \.self) { i in
                                    Circle()
                                        .fill(Color.appTextMuted)
                                        .frame(width: 8, height: 8)
                                        .opacity(0.6)
                                }
                            }
                            .padding(12)
                            .background(Color.appSurface)
                            .cornerRadius(16)
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.appBorder, lineWidth: 2))
                            Spacer()
                        }
                    }
                    
                    Color.clear.frame(height: 8).id("bottom")
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
            .onChange(of: store.chatHistory.count) { _ in
                withAnimation { proxy.scrollTo("bottom") }
            }
        }
    }
    
    // MARK: - Footer
    
    private var footerBar: some View {
        VStack(spacing: 0) {
            // Chat input bar
            if activeTab == .chat {
                HStack(spacing: 8) {
                    TextField("说点什么吧...", text: $chatInput)
                        .font(.system(size: 15, weight: .bold))
                        .padding(12)
                        .background(Color.appSurface)
                        .cornerRadius(16)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.appBorder, lineWidth: 2))
                        .disabled(store.isTyping)
                    
                    Button {
                        store.sendChat(chatInput)
                        chatInput = ""
                    } label: {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                            .frame(width: 48, height: 48)
                            .background(chatInput.trimmingCharacters(in: .whitespaces).isEmpty || store.isTyping ? Color.appBorder : Color.duoBlue)
                            .cornerRadius(16)
                            .shadow(color: chatInput.trimmingCharacters(in: .whitespaces).isEmpty ? .clear : Color.duoBlueDark, radius: 0, x: 0, y: 4)
                    }
                    .disabled(chatInput.trimmingCharacters(in: .whitespaces).isEmpty || store.isTyping)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.appBg)
                .overlay(Rectangle().frame(height: 2).foregroundColor(.appBorder), alignment: .bottom)
            }
            
            // 3 action buttons
            HStack(spacing: 12) {
                // Pat
                actionButton(
                    icon: "hand.raised.fill",
                    label: "摸一摸",
                    isActive: activeTab == .idle,
                    activeColor: .duoBlue,
                    activeShadow: .duoBlueDark
                ) {
                    store.handlePetAction()
                    activeTab = .idle
                }
                
                // Chat
                actionButton(
                    icon: activeTab == .chat ? "xmark" : "bubble.left.fill",
                    label: activeTab == .chat ? "关闭对话" : "说说话",
                    isActive: activeTab == .chat,
                    activeColor: .duoPurple,
                    activeShadow: .duoPurpleDark
                ) {
                    activeTab = activeTab == .chat ? .idle : .chat
                }
                
                // Breathe
                actionButton(
                    icon: activeTab == .breathe ? "xmark" : "wind",
                    label: activeTab == .breathe ? "结束" : "深呼吸",
                    isActive: activeTab == .breathe,
                    activeColor: .duoGreen,
                    activeShadow: .duoGreenDark
                ) {
                    if activeTab == .breathe {
                        activeTab = .idle
                    } else {
                        startBreathing()
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 28)
            .background(Color.appSurface)
            .overlay(Rectangle().frame(height: 2).foregroundColor(.appBorder), alignment: .top)
        }
    }
    
    private func actionButton(icon: String, label: String, isActive: Bool, activeColor: Color, activeShadow: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            ZStack(alignment: .bottom) {
                // 3D bottom layer (Duolingo raised effect)
                RoundedRectangle(cornerRadius: 16)
                    .fill(isActive ? activeShadow : Color.appBorderDark)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 4)
                
                // Main button face
                VStack(spacing: 6) {
                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .bold))
                    Text(label)
                        .font(.system(size: 10, weight: .black))
                        .textCase(.uppercase)
                        .tracking(0.5)
                }
                .foregroundColor(isActive ? activeShadow : .appTextMuted)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(isActive ? activeColor.opacity(0.12) : Color.appSurface)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isActive ? activeColor : Color.appBorder, lineWidth: 2)
                )
                .padding(.bottom, 4)
            }
            .frame(height: 72)
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Breathing
    
    private func startBreathing() {
        store.incrementInteraction()
        activeTab = .breathe
        breathePhase = .breatheIn
        breatheCount = 0
        runBreatheCycle()
    }
    
    private func runBreatheCycle() {
        guard activeTab == .breathe else { return }
        
        if breatheCount >= 3 {
            activeTab = .idle
            store.finishBreathing()
            breatheCount = 0
            return
        }
        
        breathePhase = .breatheIn
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [self] in
            guard activeTab == .breathe else { return }
            breathePhase = .hold
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
                guard activeTab == .breathe else { return }
                breathePhase = .breatheOut
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [self] in
                    guard activeTab == .breathe else { return }
                    breatheCount += 1
                    runBreatheCycle()
                }
            }
        }
    }
}

// MARK: - Triangle Shape

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}
