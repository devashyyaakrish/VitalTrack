import Foundation
import SwiftUI

public struct HabitModel: Identifiable {
    public let id = UUID()
    let name: String
    let emoji: String
    var currentStreak: Int
    var isCompletedToday: Bool
}

public struct HabitsView: View {
    @State private var habits = [
        HabitModel(name: "Drink Water", emoji: "💧", currentStreak: 12, isCompletedToday: true),
        HabitModel(name: "Read 10 pages", emoji: "📚", currentStreak: 4, isCompletedToday: false),
        HabitModel(name: "Meditate", emoji: "🧘", currentStreak: 21, isCompletedToday: false)
    ]
    
    @State private var showAddSheet = false
    
    public init() {}
    
    public var body: some View {
        GradientBackground {
            VStack {
                // Header
                HStack {
                    Text("Habit Tracker")
                        .heading(font: Typography.displayMedium)
                    Spacer()
                    Button(action: { showAddSheet = true }) {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .padding(12)
                            .background(LinearGradient.habitsGradient)
                            .clipShape(Circle())
                            .shadow(color: Color.habitsColor.opacity(0.5), radius: 8, x: 0, y: 4)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
                if habits.isEmpty {
                    // Empty State Hero
                    Spacer()
                    VStack(spacing: 16) {
                        Image(systemName: "checkmark.circle")
                            .font(.system(size: 64, weight: .thin))
                            .foregroundStyle(LinearGradient.habitsGradient)
                        Text("No Habits Yet")
                            .heading(font: Typography.headingLarge)
                        Text("Start building good routines today.\nSmall steps lead to big changes.")
                            .textSecondary()
                            .multilineTextAlignment(.center)
                        
                        Button("Create First Habit") {
                            showAddSheet = true
                        }
                        .glassStyle(gradient: .habitsGradient, glowColor: .habitsColor)
                        .padding(.top, 24)
                        .padding(.horizontal, 48)
                    }
                    Spacer()
                } else {
                    // Habit List
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach($habits) { $habit in
                                HabitCard(habit: $habit)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        .padding(.bottom, 100) // Space for bottom nav
                    }
                }
            }
        }
        .sheet(isPresented: $showAddSheet) {
            AddHabitSheet(habits: $habits)
        }
    }
}

struct HabitCard: View {
    @Binding var habit: HabitModel
    
    var body: some View {
        GlassCard(padding: 16) {
            HStack(spacing: 16) {
                // Emoji Icon
                Text(habit.emoji)
                    .font(.system(size: 24))
                    .padding(12)
                    .background(
                        Circle()
                            .fill(habit.isCompletedToday ? Color.successApp.opacity(0.2) : Color.glassWhite)
                    )
                    .overlay(
                        Circle()
                            .stroke(habit.isCompletedToday ? Color.successApp : Color.glassBorder, lineWidth: 1)
                    )
                
                // Content
                VStack(alignment: .leading, spacing: 4) {
                    Text(habit.name)
                        .heading()
                        .strikethrough(habit.isCompletedToday)
                        .foregroundColor(habit.isCompletedToday ? .textSecondary : .textPrimary)
                    
                    HStack(spacing: 4) {
                        Text("🔥")
                            .font(.system(size: 12))
                        Text("\(habit.currentStreak) day streak")
                            .textSecondary(font: Typography.labelSmall)
                    }
                }
                
                Spacer()
                
                // Toggle action
                Button(action: toggle) {
                    Image(systemName: habit.isCompletedToday ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 28))
                        .foregroundColor(habit.isCompletedToday ? .successApp : .textSecondary)
                }
                // Disables the default button press animation as we provide a custom pop
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    private func toggle() {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            habit.isCompletedToday.toggle()
            if habit.isCompletedToday {
                habit.currentStreak += 1
            } else {
                habit.currentStreak -= 1
            }
        }
    }
}

/// A nested view sheet for adding a new habit
struct AddHabitSheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var habits: [HabitModel]
    
    @State private var name = ""
    @State private var emoji = "🎯"
    
    let emojis = ["✅", "💧", "🏃", "📚", "🧘", "🥗", "💻", "☀️", "🎯", "🎵"]
    
    var body: some View {
        ZStack {
            Color.backgroundDeep.ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("New Habit")
                        .heading(font: Typography.displayMedium)
                    Spacer()
                }
                .padding(.top, 24)
                
                Text("Choose an emoji and give it a name")
                    .textSecondary()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer().frame(height: 24)
                
                // Emoji Picker Grid
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 16) {
                    ForEach(emojis, id: \.self) { e in
                        Button(action: { emoji = e }) {
                            Text(e)
                                .font(.system(size: 28))
                                .padding(12)
                                .background(
                                    Circle()
                                        .fill(emoji == e ? Color.primaryButton.opacity(0.3) : Color.glassWhite)
                                )
                                .overlay(
                                    Circle()
                                        .stroke(emoji == e ? Color.primaryButton : Color.glassBorder, lineWidth: 1)
                                )
                        }
                    }
                }
                .padding(.bottom, 24)
                
                GlassTextField(placeholder: "Habit Name (e.g. Meditate)", text: $name, icon: "pencil")
                
                Spacer()
                
                HStack(spacing: 16) {
                    Button("Cancel") { dismiss() }
                        .glassOutlineStyle()
                    
                    Button("Create") {
                        if !name.isEmpty {
                            habits.append(HabitModel(name: name, emoji: emoji, currentStreak: 0, isCompletedToday: false))
                            dismiss()
                        }
                    }
                    .glassStyle()
                }
                .padding(.bottom, 16)
            }
            .padding(.horizontal, 24)
        }
        .presentationDetents([.fraction(0.65)]) // Native half-sheet presentation in iOS 16+
    }
}
