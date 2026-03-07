import SwiftUI

/// A reusable SwiftUI ViewModifier that applies a frosted "glassmorphism" effect to any view.
/// This uses Apple's native `.ultraThinMaterial` combined with a subtle white linear gradient border.
public struct GlassModifier: ViewModifier {
    var cornerRadius: CGFloat
    
    public func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    // The core frosted glass effect
                    .fill(.ultraThinMaterial)
                    // A subtle tint over the glass
                    .background(Color.glassWhite)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [Color.white.opacity(0.3), Color.white.opacity(0.0)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            // Adds depth against the background
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

public extension View {
    /// Applies the standard glass effect.
    func glassEffect(cornerRadius: CGFloat = 24) -> some View {
        self.modifier(GlassModifier(cornerRadius: cornerRadius))
    }
}

/// A pre-configured Glass Card component representing a foundational building block for the app.
public struct GlassCard<Content: View>: View {
    var padding: CGFloat
    var cornerRadius: CGFloat
    let content: () -> Content
    
    public init(padding: CGFloat = 20, cornerRadius: CGFloat = 24, @ViewBuilder content: @escaping () -> Content) {
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.content = content
    }
    
    public var body: some View {
        content()
            .padding(padding)
            .glassEffect(cornerRadius: cornerRadius)
    }
}
