//
//  HomeView.swift
//  HannahGetsTomed
//
//  Created by Hannah Mercer on 07/07/2025.
//


// HomeView.swift
import SwiftUI

struct HomeView: View {
    @EnvironmentObject var dataManager: WorkoutDataManager
    @State private var showingWorkoutLog = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    TodaysWorkoutCard(showingWorkoutLog: $showingWorkoutLog)
                    WeekProgressView()
                    QuickActionsView(showingWorkoutLog: $showingWorkoutLog)
                }
                .padding()
            }
            .navigationTitle("Hannah Gets Tomed")
            .background(
                LinearGradient(
                    colors: [
                        Color.purple.opacity(0.03),
                        Color.pink.opacity(0.03),
                        Color.blue.opacity(0.02)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        }
        .sheet(isPresented: $showingWorkoutLog) {
            WorkoutLogView()
        }
    }
}

struct TodaysWorkoutCard: View {
    @Binding var showingWorkoutLog: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Today's Workout")
                .font(.title2)
                .fontWeight(.bold)
            
            Button(action: {
                showingWorkoutLog = true
            }) {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Upper Body Strength")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text("Press + Pull + Accessories")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        HStack {
                            Label("45-60 min", systemImage: "clock")
                            Spacer()
                            Label("6-8 reps", systemImage: "repeat")
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                        .font(.title3)
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.purple.opacity(0.1),
                                    Color.pink.opacity(0.1),
                                    Color.blue.opacity(0.05)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 6)
    }
}

struct WeekProgressView: View {
    let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("This Week")
                .font(.headline)
                .fontWeight(.semibold)
            
            HStack(spacing: 16) {
                ForEach(Array(days.enumerated()), id: \.offset) { index, day in
                    VStack(spacing: 8) {
                        Text(day)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        
                        Circle()
                            .fill(statusColor(for: index))
                            .frame(width: 36, height: 36)
                            .overlay(
                                statusIcon(for: index)
                                    .foregroundColor(.white)
                                    .font(.system(size: 16, weight: .semibold))
                            )
                    }
                }
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 6)
    }
    
    func statusColor(for index: Int) -> Color {
        switch index {
        case 0, 1: return .green
        case 2: return .purple
        case 3: return .orange
        case 4, 5: return .gray.opacity(0.3)
        default: return .gray
        }
    }
    
    func statusIcon(for index: Int) -> some View {
        switch index {
        case 0, 1: return Image(systemName: "checkmark")
        case 2: return Image(systemName: "play.fill")
        case 3: return Image(systemName: "pause.fill")
        case 4, 5: return Image(systemName: "circle")
        default: return Image(systemName: "circle")
        }
    }
}

struct QuickActionsView: View {
    @Binding var showingWorkoutLog: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            QuickActionButton(
                title: "Log Today",
                icon: "checkmark.circle.fill",
                color: .green
            ) {
                showingWorkoutLog = true
            }
            
            QuickActionButton(
                title: "View Tomorrow",
                icon: "calendar",
                color: .blue
            ) {
                // TODO: Navigate to tomorrow's workout
            }
            
            QuickActionButton(
                title: "Swap Workout",
                icon: "arrow.2.squarepath",
                color: .orange
            ) {
                // TODO: Show swap options
            }
        }
    }
}

struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
            )
        }
    }
}