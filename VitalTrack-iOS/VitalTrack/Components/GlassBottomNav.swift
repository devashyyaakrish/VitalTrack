import SwiftUI

/// Defines the tabs available in the main navigation
public enum AppTab: Int, CaseIterable {
    case dashboard = 0
    case trackers = 1
    case habits = 2
    case analytics = 3
    case settings = 4
    
    var iconName: String {
        switch self {
        case .dashboard: return "square.grid.2x2"
        case .trackers:  return "heart.text.square"
        case .habits:    return "checklist"
        case .analytics: return "chart.bar.xaxis"
        case .settings:  return "gearshape"
        }
    }
    
    var label: String {
        switch self {
        case .dashboard: return "Home"
        case .trackers:  return "Trackers"
        case .habits:    return "Habits"
        case .analytics: return "Analytics"
        case .settings:  return "Settings"
        }
    }
}

/// A custom floating frosted glass bottom navigation bar.
public struct GlassBottomNav: View {
    @Binding var selectedTab: AppTab
    
    public init(selectedTab: Binding<AppTab>) {
        self._selectedTab = selectedTab
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases, id: \.self) { tab in
                let isActive = tab == selectedTab
                
                VStack(spacing: 4) {
                    Image(systemName: isActive ? "\(tab.iconName).fill" : tab.iconName)
                        .font(.system(size: 22))
                        .foregroundColor(isActive ? .primaryButton : .textSecondary)
                    
                    if isActive {
                        Circle()
                            .fill(Color.primaryButton)
                            .frame(width: 4, height: 4)
                            .shadow(color: Color.glowBlue, radius: 4, x: 0, y: 0)
                            // Matched geometry effect equivalent handled implicitly by SwiftUI animating insertion
                            .transition(.scale.combined(with: .opacity))
                    } else {
                        // Invisible spacer to prevent jittering when the dot appears
                        Circle()
                            .fill(Color.clear)
                            .frame(width: 4, height: 4)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .contentShape(Rectangle()) // Ensures tap target fills spacing area
                .onTapGesture {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = tab
                    }
                    // Haptic response on tap
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                }
            }
        }
        .padding(.horizontal, 8)
        .padding(.bottom, 8)
        .background(
            // Top rounded frosted glass background that ignores the bottom safe area
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(.ultraThinMaterial)
                .background(Color.glassWhite)
                .overlay(
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .stroke(
                            LinearGradient(
                                colors: [Color.white.opacity(0.3), Color.white.opacity(0.0)],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: 1
                        )
                )
        )
        // Offset downwards slightly so it rests cleanly on the home indicator bounds
        .ignoresSafeArea(edges: .bottom)
        .padding(.top, 10)
    }
}
