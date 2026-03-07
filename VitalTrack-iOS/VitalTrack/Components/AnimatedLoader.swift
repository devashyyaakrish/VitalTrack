import SwiftUI

public struct AnimatedLoader: View {
    @State private var isPulsing = false
    
    var color: Color = .primaryButton
    
    public init(color: Color = .primaryButton) {
        self.color = color
    }
    
    public var body: some View {
        ZStack {
            // Core circle
            Circle()
                .fill(color)
                .frame(width: 20, height: 20)
            
            // Outer pulsing ring 1
            Circle()
                .strokeBorder(color, lineWidth: 2)
                .frame(width: 40, height: 40)
                .scaleEffect(isPulsing ? 1.5 : 0.8)
                .opacity(isPulsing ? 0 : 1)
            
            // Outer pulsing ring 2
            Circle()
                .strokeBorder(color, lineWidth: 2)
                .frame(width: 60, height: 60)
                .scaleEffect(isPulsing ? 1.5 : 0.5)
                .opacity(isPulsing ? 0 : 0.6)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: false)) {
                isPulsing = true
            }
        }
    }
}

public struct AnimatedCheckmark: View {
    @State private var animateDraw = false
    @State private var animateScale = false
    
    var color: Color = .successApp
    
    public init(color: Color = .successApp) {
        self.color = color
    }
    
    public var body: some View {
        ZStack {
            Circle()
                .fill(color.opacity(0.15))
                .frame(width: 80, height: 80)
                .scaleEffect(animateScale ? 1.0 : 0.0)
            
            Image(systemName: "checkmark")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(color)
                .scaleEffect(animateScale ? 1.0 : 0.0)
                .clipShape(
                    Rectangle()
                        .offset(x: animateDraw ? 0 : -80)
                )
        }
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                animateScale = true
            }
            withAnimation(.easeOut(duration: 0.4).delay(0.2)) {
                animateDraw = true
            }
        }
    }
}
