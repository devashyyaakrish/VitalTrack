import SwiftUI

public struct DashboardView: View {
    // Array of metrics providing simulated state data
    @State private var metrics = MockData.sharedMetrics
    
    // Animate entries on view appear
    @State private var showHero = false
    @State private var showMetrics = false
    
    // Grid configuration for 2x2 layout
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    public init() {}
    
    public var body: some View {
        GradientBackground {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    
                    // MARK: - Hero Section
                    if showHero {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Good Morning,")
                                    .heading(font: Typography.displayMedium)
                                Spacer()
                                Image(systemName: "bell.badge.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                    .symbolRenderingMode(.multicolor)
                                    .glassEffect(cornerRadius: 12)
                                    .padding(8)
                            }
                            
                            Text("Devashyya")
                                .font(Typography.displayLarge)
                                .foregroundColor(.primaryButton)
                            
                            GlassCard(padding: 16, cornerRadius: 20) {
                                HStack(spacing: 12) {
                                    Image(systemName: "quote.opening")
                                        .foregroundColor(.secondaryAccent)
                                    Text("Consistency is the core of progress. Keep moving!")
                                        .textSecondary(font: Typography.bodyMedium)
                                        .italic()
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.top, 16)
                        }
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    
                    // MARK: - Metric Grid
                    if showMetrics {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(Array(metrics.enumerated()), id: \.element.id) { index, metric in
                                MetricCard(metric: metric, index: index)
                            }
                        }
                        .padding(.bottom, 120) // Give bottom space so GlassBottomNav doesn't overlap
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 24) // Adds safe area equivalent
            }
        }
        .onAppear {
            // Orchestrate staggered elegant entry animations
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                showHero = true
            }
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2)) {
                showMetrics = true
            }
        }
    }
}

/// A nested view extracting the individual metric card logic
fileprivate struct MetricCard: View {
    let metric: MetricData
    let index: Int
    
    @State private var animateIn = false
    
    var body: some View {
        GlassCard(padding: 16, cornerRadius: 24) {
            VStack {
                HStack {
                    ZStack {
                        Circle()
                            .fill(metric.gradient)
                            .frame(width: 32, height: 32)
                        Image(systemName: metric.iconName)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    }
                    Spacer()
                    // Reusable Metric Ring imported from Components/
                    MetricRing(value: metric.value, gradient: metric.gradient, lineWidth: 6) {
                        EmptyView()
                    }
                    .frame(width: 24, height: 24)
                }
                
                Spacer().frame(height: 24)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(metric.displayValue)
                        .heading(font: Typography.headingMedium)
                    Text(metric.title)
                        .textSecondary(font: Typography.labelMedium)
                    Text(metric.subtitle)
                        .textTertiary()
                        .font(Typography.labelSmall)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        // Applying a slight y-offset based on animation state for staggered entry per-card
        .offset(y: animateIn ? 0 : 50)
        .opacity(animateIn ? 1 : 0)
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7).delay(Double(index) * 0.1)) {
                animateIn = true
            }
        }
    }
}
