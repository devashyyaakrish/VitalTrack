import SwiftUI

/// Root Application Router coordinating global authentication state
public struct AppView: View {
    @State private var isAuthenticated = false
    @State private var showRegister = false
    
    public init() {}
    
    public var body: some View {
        Group {
            if isAuthenticated {
                // Shell out to Main Authenticated App flow
                MainTabView()
            } else {
                // Shell Auth flow
                LoginView(
                    isAuthenticated: $isAuthenticated,
                    showRegister: $showRegister
                )
                .sheet(isPresented: $showRegister) {
                    RegisterView(showRegister: $showRegister)
                        // Uses the new iOS 16 detent to snap but allow expanding
                        .presentationDetents([.large])
                        .presentationDragIndicator(.visible)
                }
            }
        }
        // Applying global preferred color scheme here enforces the dark aesthetic universally against
        // any sub-components that might attempt to default light scheme
        .preferredColorScheme(.dark)
        // Spring bounce effect when switching main app states
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: isAuthenticated)
    }
}
