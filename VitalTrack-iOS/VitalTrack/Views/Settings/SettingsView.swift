import SwiftUI

public struct SettingsView: View {
    @State private var isDarkMode = true
    @State private var useMetric = true
    @State private var waterReminders = true
    @State private var habitReminders = true
    
    @State private var showSignOutAlert = false
    @State private var showDeleteAlert = false
    
    public init() {}
    
    public var body: some View {
        GradientBackground {
            VStack {
                HStack {
                    Text("Settings")
                        .heading(font: Typography.displayMedium)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        
                        // MARK: - Profile Card
                        GlassCard(padding: 20) {
                            HStack(spacing: 16) {
                                // Avatar Circle
                                Text("D")
                                    .font(Typography.displayMedium)
                                    .foregroundColor(.white)
                                    .frame(width: 64, height: 64)
                                    .background(Color.white.opacity(0.2))
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white.opacity(0.4), lineWidth: 1))
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Devashyya")
                                        .heading(font: Typography.headingMedium)
                                    Text("user@example.com")
                                        .textSecondary(font: Typography.bodyMedium)
                                }
                                Spacer()
                            }
                        }
                        // Applying a deep purle/blue distinct gradient overlaid on the glass card
                        .background(LinearGradient(colors: [Color(hex: "2563EB"), Color(hex: "7C3AED")], startPoint: .topLeading, endPoint: .bottomTrailing).mask(RoundedRectangle(cornerRadius: 24)))
                        // Ensure the glass material stroke still outlines
                        .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color.white.opacity(0.2), lineWidth: 1))
                        
                        // MARK: - Preferences
                        SettingsSection(header: "PREFERENCES") {
                            SettingsToggle(title: "Dark Mode", icon: "moon.fill", iconColor: .secondaryAccent, isOn: $isDarkMode)
                            Divider().background(Color.glassBorder).padding(.leading, 48)
                            SettingsToggle(title: "Metric Units", subtitle: useMetric ? "kg, cm, ml" : "lbs, ft, oz", icon: "ruler.fill", iconColor: .stepsColor, isOn: $useMetric)
                        }
                        
                        // MARK: - Notifications
                        SettingsSection(header: "NOTIFICATIONS") {
                            SettingsToggle(title: "Water Reminders", icon: "drop.fill", iconColor: .waterColor, isOn: $waterReminders)
                            Divider().background(Color.glassBorder).padding(.leading, 48)
                            SettingsToggle(title: "Habit Reminders", icon: "bell.fill", iconColor: .habitsColor, isOn: $habitReminders)
                        }
                        
                        // MARK: - Account Actions
                        SettingsSection(header: "ACCOUNT") {
                            Button(action: { showSignOutAlert = true }) {
                                SettingsRow(title: "Sign Out", titleColor: .warningApp, icon: "rectangle.portrait.and.arrow.right", iconColor: .warningApp)
                            }
                            Divider().background(Color.glassBorder).padding(.leading, 48)
                            Button(action: { showDeleteAlert = true }) {
                                SettingsRow(title: "Delete Account", titleColor: .errorApp, icon: "trash.fill", iconColor: .errorApp)
                            }
                        }
                        
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 120)
                }
            }
        }
        // Native Native alerts translating custom glass alerts from Flutter
        .alert("Sign Out", isPresented: $showSignOutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Sign Out", role: .destructive) {
                // Logout logic
            }
        } message: {
            Text("Are you sure you want to sign out?")
        }
        .alert("Delete Account?", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                // Delete logic
            }
        } message: {
            Text("This action is permanent and will delete all your data.")
        }
    }
}

// MARK: - UI Helpers

fileprivate struct SettingsSection<Content: View>: View {
    let header: String
    let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(header)
                .font(Typography.labelSmall)
                .tracking(1.4)
                .foregroundColor(.textTertiary)
                .padding(.leading, 8)
            
            VStack(spacing: 0) {
                content()
            }
            .glassEffect(cornerRadius: 20)
        }
    }
}

fileprivate struct SettingsToggle: View {
    let title: String
    var subtitle: String? = nil
    let icon: String
    let iconColor: Color
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(iconColor)
                .frame(width: 32, height: 32)
                .background(iconColor.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .heading(font: Typography.labelLarge)
                if let sub = subtitle {
                    Text(sub)
                        .textSecondary(font: Typography.labelSmall)
                }
            }
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(.primaryButton)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .contentShape(Rectangle()) // makes padding tappable for toggles
    }
}

fileprivate struct SettingsRow: View {
    let title: String
    let titleColor: Color
    let icon: String
    let iconColor: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(iconColor)
                .frame(width: 32, height: 32)
                .background(iconColor.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            Text(title)
                .heading(font: Typography.labelLarge)
                .foregroundColor(titleColor)
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .contentShape(Rectangle())
    }
}
