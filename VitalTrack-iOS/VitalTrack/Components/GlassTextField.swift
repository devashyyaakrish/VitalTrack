import SwiftUI

/// A frosted glass text field with scaling animation on focus and custom styling.
public struct GlassTextField: View {
    let placeholder: String
    @Binding var text: String
    var icon: String?
    var isSecure: Bool
    
    @FocusState private var isFocused: Bool
    
    public init(placeholder: String, text: Binding<String>, icon: String? = nil, isSecure: Bool = false) {
        self.placeholder = placeholder
        self._text = text
        self.icon = icon
        self.isSecure = isSecure
    }
    
    public var body: some View {
        HStack(spacing: 16) {
            if let iconName = icon {
                Image(systemName: iconName)
                    .font(.system(size: 20))
                    .foregroundColor(isFocused ? .primaryButton : .textSecondary)
            }
            
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                        .focused($isFocused)
                } else {
                    TextField(placeholder, text: $text)
                        .focused($isFocused)
                }
            }
            .font(Typography.bodyLarge)
            .foregroundColor(.textPrimary)
            // Colorise placeholder Text inside the underlying UIKit view bridging if necessary
            // or rely on SwiftUI 3+ .preferredColorScheme if modifying placeholder is strictly needed
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        // Background Frosted Layer
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.ultraThinMaterial)
                .background(Color.glassWhite)
        )
        // Border Layer (Dynamic based on focus)
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(
                    isFocused ? Color.primaryButton : Color.glassBorder,
                    lineWidth: isFocused ? 2 : 1
                )
        )
        // Subtle drop shadow
        .shadow(
            color: isFocused ? Color.glowBlue.opacity(0.3) : .clear,
            radius: 8,
            x: 0,
            y: 4
        )
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isFocused)
    }
}
