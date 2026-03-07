import SwiftUI

/// Base background screen layout for all Views. Applies a dark, dynamic gradient globally.
public struct GradientBackground<Content: View>: View {
    let content: () -> Content
    
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    public var body: some View {
        ZStack {
            // Screen spanning background
            LinearGradient.heroGradient
                .ignoresSafeArea()
            
            // Subtle animated glowing orb in top-right for depth
            Circle()
                .fill(Color.glowBlue)
                .frame(width: 300, height: 300)
                .blur(radius: 80)
                .offset(x: 100, y: -150)
                .opacity(0.5)
                .ignoresSafeArea()
            
            content()
        }
    }
}

public extension View {
    /// Wraps the current view inside a `GradientBackground`
    func withGradientBackground() -> some View {
        GradientBackground {
            self
        }
    }
}
