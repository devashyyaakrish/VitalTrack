import SwiftUI
import Charts

/// Mock data mapping days of the week to analytical values
struct DayData: Identifiable {
    let id = UUID()
    let day: String
    let value: Double
}

public struct AnalyticsView: View {
    @State private var isWeekly = true
    
    // Sample Data Sets
    let waterData = [
        DayData(day: "Mon", value: 1200), DayData(day: "Tue", value: 1800), DayData(day: "Wed", value: 2100),
        DayData(day: "Thu", value: 1600), DayData(day: "Fri", value: 2400), DayData(day: "Sat", value: 1400), DayData(day: "Sun", value: 2200)
    ]
    let stepData = [
        DayData(day: "Mon", value: 4500), DayData(day: "Tue", value: 8200), DayData(day: "Wed", value: 10400),
        DayData(day: "Thu", value: 6500), DayData(day: "Fri", value: 11200), DayData(day: "Sat", value: 5400), DayData(day: "Sun", value: 9800)
    ]
    
    public init() {}
    
    public var body: some View {
        GradientBackground {
            VStack {
                // Header
                HStack {
                    Text("Analytics")
                        .heading(font: Typography.displayMedium)
                    Spacer()
                    
                    // Period Toggle Pill
                    Button(action: { isWeekly.toggle() }) {
                        HStack(spacing: 6) {
                            Image(systemName: "calendar")
                            Text(isWeekly ? "This Week" : "Overview")
                        }
                        .font(Typography.labelMedium)
                        .foregroundColor(.primaryButton)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .glassEffect(cornerRadius: 20)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        
                        ChartCard(
                            title: "Water Intake",
                            subtitle: "ml · this week",
                            icon: "drop.fill",
                            gradient: .waterGradient,
                            color: .waterColor
                        ) {
                            Chart(waterData) { item in
                                BarMark(
                                    x: .value("Day", item.day),
                                    y: .value("ML", item.value)
                                )
                                // Gradient fill matching data
                                .foregroundStyle(.linearGradient(
                                    colors: [Color.waterColor.opacity(0.8), Color.waterColor],
                                    startPoint: .bottom,
                                    endPoint: .top)
                                )
                                .cornerRadius(6)
                            }
                            // Customizing axis grids
                            .chartYAxis {
                                AxisMarks(position: .leading, values: .automatic(desiredCount: 3)) {
                                    AxisGridLine(stroke: StrokeStyle(lineWidth: 1, dash: [4, 4])).foregroundStyle(.white.opacity(0.1))
                                    AxisValueLabel().foregroundStyle(.white.opacity(0.5))
                                }
                            }
                            .chartXAxis {
                                AxisMarks {
                                    AxisValueLabel().foregroundStyle(.white.opacity(0.5))
                                }
                            }
                        }
                        
                        ChartCard(
                            title: "Step Count",
                            subtitle: "steps · this week",
                            icon: "shoeprints.fill",
                            gradient: .stepsGradient,
                            color: .stepsColor
                        ) {
                            Chart(stepData) { item in
                                LineMark(
                                    x: .value("Day", item.day),
                                    y: .value("Steps", item.value)
                                )
                                .lineStyle(StrokeStyle(lineWidth: 3, lineCap: .round))
                                .foregroundStyle(Color.stepsColor)
                                
                                AreaMark(
                                    x: .value("Day", item.day),
                                    y: .value("Steps", item.value)
                                )
                                .foregroundStyle(.linearGradient(
                                    colors: [Color.stepsColor.opacity(0.3), Color.clear],
                                    startPoint: .top,
                                    endPoint: .bottom)
                                )
                                
                                PointMark(
                                    x: .value("Day", item.day),
                                    y: .value("Steps", item.value)
                                )
                                .foregroundStyle(Color.backgroundDark)
                            }
                            .chartYAxis {
                                AxisMarks(position: .leading, values: .automatic(desiredCount: 3)) {
                                    AxisGridLine(stroke: StrokeStyle(lineWidth: 1, dash: [4, 4])).foregroundStyle(.white.opacity(0.1))
                                    AxisValueLabel().foregroundStyle(.white.opacity(0.5))
                                }
                            }
                            .chartXAxis {
                                AxisMarks {
                                    AxisValueLabel().foregroundStyle(.white.opacity(0.5))
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 120) // Bottom Nav buffer
                }
            }
        }
    }
}

fileprivate struct ChartCard<Content: View>: View {
    let title: String
    let subtitle: String
    let icon: String
    let gradient: LinearGradient
    let color: Color
    let content: () -> Content
    
    var body: some View {
        GlassCard(padding: 20) {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 12) {
                    Image(systemName: icon)
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                        .frame(width: 32, height: 32)
                        .background(gradient)
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(title)
                            .heading(font: Typography.headingSmall)
                        Text(subtitle)
                            .textSecondary(font: Typography.labelSmall)
                    }
                }
                
                content()
                    .frame(height: 160)
            }
        }
    }
}
