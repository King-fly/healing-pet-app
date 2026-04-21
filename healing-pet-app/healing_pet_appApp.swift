import SwiftUI

@main
struct healing_pet_appApp: App {
    @StateObject private var store = PetStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
