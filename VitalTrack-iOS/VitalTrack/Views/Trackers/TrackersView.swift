import SwiftUI

enum TrackerTab: String, CaseIterable {
    case water = "Water"
    case steps = "Steps"
    case calories = "Meals"
    case sleep = "Sleep"
    
    var color: Color {
        switch self {
        case .water: return .waterColor
        case .steps: return .stepsColor
        case .calories: return .caloriesColor
        case .sleep: return .sleepColor
        }
    }
}

public struct TrackersView: View {
    @State private var selectedTab: TrackerTab = .water
    @Namespace private var animation
    
    // Mock Data
    @State private var waterAmount: Double = 0.65
    @State private var stepAmount: Double = 0.82
    
    public init() {}
    
    public var body: some View {
        GradientBackground {
            VStack {
                // Header
                HStack {
                    Text("Health Trackers")
                        .heading(font: Typography.displayMedium)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
                // Segmented Pill Picker
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(TrackerTab.allCases, id: \.self) { tab in
                            let isSelected = selectedTab == tab
                            
                            Text(tab.rawValue)
                                .font(Typography.labelLarge)
                                .foregroundColor(isSelected ? .white : .textSecondary)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(
                                    ZStack {
                                        if isSelected {
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(tab.color.opacity(0.8))
                                                .matchedGeometryEffect(id: "TAB", in: animation)
                                        } else {
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(Color.glassWhite)
                                        }
                                    }
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(isSelected ? tab.color : Color.glassBorder, lineWidth: 1)
                                )
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        selectedTab = tab
                                    }
                                    let impact = UIImpactFeedbackGenerator(style: .light)
                                    impact.impactOccurred()
                                }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                }
                
                // Tab Content
                TabView(selection: $selectedTab) {
                    WaterTrackingView(value: $waterAmount)
                        .tag(TrackerTab.water)
                    
                    StepsTrackingView(value: $stepAmount)
                        .tag(TrackerTab.steps)
                    
                    Text("Meals placeholder - Glass list representation")
                        .tag(TrackerTab.calories)
                    
                    Text("Sleep placeholder - Glass time pickers")
                        .tag(TrackerTab.sleep)
                }
                .tabViewStyle(.page(indexDisplayMode: .never)) // Allows swiping between views native to SwiftUI
                
                Spacer()
            }
        }
    }
}

// MARK: - SubViews

struct WaterTrackingView: View {
    @Binding var value: Double
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            MetricRing(value: value, gradient: .waterGradient, lineWidth: 16) {
                VStack {
                    Image(systemName: "drop.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.waterColor)
                        .padding(.bottom, 8)
                    Text("\(Int(value * 2500)) ml")
                        .heading(font: Typography.displayMedium)
                    Text("Goal: 2,500 ml")
                        .textSecondary()
                }
            }
            .frame(width: 240, height: 240)
            
            GlassCard {
                HStack(spacing: 20) {
                    Button("+250ml") { add(0.1) }.glassStyle(gradient: .waterGradient)
                    Button("+500ml") { add(0.2) }.glassStyle(gradient: .waterGradient)
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
    }
    
    private func add(_ amt: Double) {
        withAnimation(.spring()) {
            value = min(1.0, value + amt)
        }
    }
}

struct StepsTrackingView: View {
    @Binding var value: Double
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            MetricRing(value: value, gradient: .stepsGradient, lineWidth: 16) {
                VStack {
                    Image(systemName: "shoeprints.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.stepsColor)
                        .padding(.bottom, 8)
                    Text("\(Int(value * 10000))")
                        .heading(font: Typography.displayMedium)
                    Text("Goal: 10,000 steps")
                        .textSecondary()
                }
            }
            .frame(width: 240, height: 240)
            
            GlassCard {
                HStack(spacing: 20) {
                    Button("Sync Device") { }.glassStyle(gradient: .stepsGradient)
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
    }
}
