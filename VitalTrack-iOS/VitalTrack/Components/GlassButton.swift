import SwiftUI

/// A native ButtonStyle creating a premium glass interaction with
/// scaling, opacity shifts, and haptic feedback.
public struct GlassButtonStyle: ButtonStyle {
    var isOutlined: Bool
    var gradient: LinearGradient
    var glowColor: Color
    var cornerRadius: CGFloat
    
    public init(
        isOutlined: Bool = false,
        gradient: LinearGradient = LinearGradient.primaryGradient,
        glowColor: Color = Color.glowBlue,
        cornerRadius: CGFloat = 16
    ) {
        self.isOutlined = isOutlined
        self.gradient = gradient
        self.glowColor = glowColor
        self.cornerRadius = cornerRadius
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Typography.button)
            .foregroundColor(.white)
            .padding(.vertical, 16)
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity)
            .background(
                Group {
                    if isOutlined {
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .stroke(gradient, lineWidth: 2)
                            .background(
                                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                                    .fill(.ultraThinMaterial)
                            )
                    } else {
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .fill(gradient)
                            // Glowing aura matching the gradient color
                            .shadow(color: glowColor.opacity(configuration.isPressed ? 0.2 : 0.6), radius: 12, x: 0, y: 6)
                    }
                }
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.85 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
            // Inject native haptic feedback
            .onChange(of: configuration.isPressed) { isPressed in
                if isPressed {
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                }
            }
    }
}

public extension Button {
    /// Primary solid glass button
    func glassStyle(
        gradient: LinearGradient = .primaryGradient,
        glowColor: Color = .glowBlue,
        cornerRadius: CGFloat = 16
    ) -> some View {
        self.buttonStyle(GlassButtonStyle(
            isOutlined: false,
            gradient: gradient,
            glowColor: glowColor,
            cornerRadius: cornerRadius
        ))
    }
    
    /// Secondary outlined glass button
    func glassOutlineStyle(
        gradient: LinearGradient = .primaryGradient,
        cornerRadius: CGFloat = 16
    ) -> some View {
        self.buttonStyle(GlassButtonStyle(
            isOutlined: true,
            gradient: gradient,
            glowColor: .clear,
            cornerRadius: cornerRadius
        ))
    }
}
