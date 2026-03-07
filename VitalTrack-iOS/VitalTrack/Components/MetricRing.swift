import SwiftUI

/// An animated circular progress indicator matching the Flutter MetricRing widget.
/// Draws a gradient stroke with native `.spring()` animation on value changes.
public struct MetricRing<CenteredContent: View>: View {
    var value: Double /// Progress from 0.0 to 1.0
    var gradient: LinearGradient
    var lineWidth: CGFloat
    let content: () -> CenteredContent
    
    @State private var animatedValue: Double = 0.0
    
    public init(
        value: Double,
        gradient: LinearGradient = .primaryGradient,
        lineWidth: CGFloat = 12,
        @ViewBuilder content: @escaping () -> CenteredContent
    ) {
        self.value = max(0.0, min(1.0, value)) // Clamp between 0 and 1
        self.gradient = gradient
        self.lineWidth = lineWidth
        self.content = content
    }
    
    public var body: some View {
        ZStack {
            // Background track (semi-transparent white/gray)
            Circle()
                .stroke(
                    Color.white.opacity(0.08),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
            
            // Foreground progress indicator (gradient stroke)
            Circle()
                .trim(from: 0.0, to: animatedValue)
                .stroke(
                    gradient,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90)) // Start at the top/12 o'clock
                .shadow(color: gradientShadowColor.opacity(0.4), radius: 8, x: 0, y: 0)
                // Spring animation mapping local state to input value binding
                .animation(.spring(response: 0.8, dampingFraction: 0.7, blendDuration: 0), value: animatedValue)
            
            // Centered child content
            content()
        }
        // Trigger the grow animation on initial load and keep observing prop changes
        .onAppear {
            animatedValue = value
        }
        .onChange(of: value) { newValue in
            animatedValue = newValue
        }
    }
    
    /// Derives an approximate shadow color from the gradient (defaults to primary glow if complex)
    private var gradientShadowColor: Color {
        // We'll use the generic glowBlue for shadows mapped to the ring
        // In a real implementation you might map the specific metric context (water/step) directly here
        return Color.glowBlue
    }
}
