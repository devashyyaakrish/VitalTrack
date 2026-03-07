import Foundation
import SwiftUI

/// Shared basic mock models for SwiftUI prototyping
public struct MetricData: Identifiable {
    public let id = UUID()
    let title: String
    let subtitle: String
    let value: Double // 0 to 1 progress
    let displayValue: String
    let iconName: String
    let color: Color
    let gradient: LinearGradient
}

public struct MockData {
    public static let sharedMetrics = [
        MetricData(title: "Water", subtitle: "Goal: 2.5L", value: 0.65, displayValue: "1.6L", iconName: "drop.fill", color: .waterColor, gradient: .waterGradient),
        MetricData(title: "Steps", subtitle: "Goal: 10,000", value: 0.8, displayValue: "8,432", iconName: "shoeprints.fill", color: .stepsColor, gradient: .stepsGradient),
        MetricData(title: "Calories", subtitle: "Goal: 2,400 kcal", value: 0.5, displayValue: "1,200", iconName: "flame.fill", color: .caloriesColor, gradient: .caloriesGradient),
        MetricData(title: "Sleep", subtitle: "Goal: 8h", value: 0.9, displayValue: "7.2h", iconName: "moon.zzz.fill", color: .sleepColor, gradient: .sleepGradient)
    ]
}
