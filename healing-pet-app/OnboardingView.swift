import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var store: PetStore
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            // Pet preview
            VStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 32)
                        .fill(Color.appSurface)
                        .frame(width: 128, height: 128)
                        .overlay(
                            RoundedRectangle(cornerRadius: 32)
                                .stroke(Color.appBorder, lineWidth: 4)
                        )
                        .shadow(color: .black.opacity(0.1), radius: 12, y: 6)
                    
                    Image(systemName: store.state.petType.icon)
                        .font(.system(size: 56))
                        .foregroundColor(Color.petColor(for: store.state.petType))
                }
                
                Button {
                    store.cyclePetType()
                } label: {
                    Text("换一个宠物")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.duoBlue)
                        .textCase(.uppercase)
                        .tracking(1)
                }
            }
            .padding(.bottom, 32)
            
            // Title
            Text("领养虚拟伴侣")
                .font(.system(size: 24, weight: .black))
                .foregroundColor(.appText)
                .padding(.bottom, 8)
            
            Text("随时点开，无压力陪伴")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.appTextMuted)
                .padding(.bottom, 40)
            
            // Name input
            VStack(spacing: 24) {
                TextField("给它起个名字...", text: $store.state.petName)
                    .font(.system(size: 18, weight: .bold))
                    .multilineTextAlignment(.center)
                    .padding(16)
                    .background(Color.appSurface)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.appBorder, lineWidth: 2)
                    )
                
                Button {
                    store.startOnboarding()
                } label: {
                    Text("开始陪伴")
                        .font(.system(size: 18, weight: .black))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(store.state.petName.trimmingCharacters(in: .whitespaces).isEmpty ? Color.appBorder : Color.duoGreen)
                        .cornerRadius(20)
                        .shadow(color: store.state.petName.trimmingCharacters(in: .whitespaces).isEmpty ? .clear : Color.duoGreenDark, radius: 0, x: 0, y: 6)
                }
                .disabled(store.state.petName.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .padding(.horizontal, 32)
            
            Spacer()
        }
        .background(Color.appBg.ignoresSafeArea())
    }
}
