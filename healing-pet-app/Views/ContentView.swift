import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: PetStore
    
    var body: some View {
        if store.state.hasOnboarded {
            PetMainView()
        } else {
            OnboardingView()
        }
    }
}
 
