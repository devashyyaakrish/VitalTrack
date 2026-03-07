import SwiftUI

public struct MainTabView: View {
    @State private var selectedTab: AppTab = .dashboard
    
    public init() {}
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            
            // Tab Content
            switch selectedTab {
            case .dashboard:
                Text("Dashboard Content") // Placeholder
                    .withGradientBackground()
            case .trackers:
                Text("Trackers Content") // Placeholder
                    .withGradientBackground()
            case .habits:
                Text("Habits Content") // Placeholder
                    .withGradientBackground()
            case .analytics:
                Text("Analytics Content") // Placeholder
                    .withGradientBackground()
            case .settings:
                Text("Settings Content") // Placeholder
                    .withGradientBackground()
            }
            
            // Floating Frosted Tab Bar
            GlassBottomNav(selectedTab: $selectedTab)
                // Adds a padding bumper at the bottom to offset it slightly from the safe area
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .transition(.opacity) // Fade in transition when authed
    }
}
