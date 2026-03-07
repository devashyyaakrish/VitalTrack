import SwiftUI

/// Premium Glassmorphism Color Palette for VitalTrack
public extension Color {
    // MARK: - Core Theme
    /// Deep Navy base background
    static let backgroundDark = Color(hex: "0A0E27")
    /// Deep Black/Indigo alternative
    static let backgroundDeep = Color(hex: "05081A")
    
    /// Primary Accent (Electric Indigo/Blue)
    static let primaryButton = Color(hex: "4F46E5")
    /// Secondary Accent (Vibrant Cyan)
    static let secondaryAccent = Color(hex: "06B6D4")
    
    // MARK: - Semantic Colors
    static let successApp = Color(hex: "10B981")
    static let warningApp = Color(hex: "F59E0B")
    static let errorApp   = Color(hex: "EF4444")
    
    // MARK: - Metric Trackers
    static let waterColor    = Color(hex: "3B82F6")
    static let stepsColor    = Color(hex: "10B981")
    static let caloriesColor = Color(hex: "F97316")
    static let sleepColor    = Color(hex: "8B5CF6")
    static let habitsColor   = Color(hex: "EC4899")
    
    // MARK: - Glassmorphism Tokens
    /// Ultra-thin white for frosted glass layers
    static let glassWhite  = Color.white.opacity(0.12)
    /// Highlight borders for glass edges
    static let glassBorder = Color.white.opacity(0.20)
    /// Subtle deep glow for shadows
    static let glowBlue    = Color(hex: "4F46E5").opacity(0.4)
    
    // MARK: - Text
    static let textPrimary   = Color.white
    static let textSecondary = Color.white.opacity(0.65)
    static let textTertiary  = Color.white.opacity(0.40)
}

// MARK: - Gradients
public extension LinearGradient {
    /// Hero background gradient
    static let heroGradient = LinearGradient(
        colors: [Color.backgroundDeep, Color.backgroundDark],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    /// Primary button gradient
    static let primaryGradient = LinearGradient(
        colors: [Color(hex: "6366F1"), Color(hex: "4F46E5")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    /// Water tracking gradient
    static let waterGradient = LinearGradient(
        colors: [Color(hex: "60A5FA"), Color(hex: "3B82F6")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    /// Steps tracking gradient
    static let stepsGradient = LinearGradient(
        colors: [Color(hex: "34D399"), Color(hex: "10B981")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    /// Calories tracking gradient
    static let caloriesGradient = LinearGradient(
        colors: [Color(hex: "FB923C"), Color(hex: "F97316")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    /// Sleep tracking gradient
    static let sleepGradient = LinearGradient(
        colors: [Color(hex: "A78BFA"), Color(hex: "8B5CF6")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    /// Habits tracking gradient
    static let habitsGradient = LinearGradient(
        colors: [Color(hex: "F472B6"), Color(hex: "EC4899")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// MARK: - Hex Initialization Extension
public extension Color {
    /// Initializes a Color from a hex string (e.g. "0A0E27")
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
