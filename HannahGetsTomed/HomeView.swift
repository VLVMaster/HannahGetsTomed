//
//  HomeView.swift
//  HannahGetsTomed
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var dataManager: WorkoutDataManager
    @EnvironmentObject var exerciseDB: ExerciseDatabase
    @State private var showingWorkoutLog = false
    @State private var showingWorkoutDetail = false
    @State private var selectedWorkout: GeneratedWorkout?
    
    var todaysWorkout: GeneratedWorkout? {
        let today = Calendar.current.component(.weekday, from: Date())
        let workoutIndex = (today - 1) % exerciseDB.generatedWorkouts.count
        return exerciseDB.generatedWorkouts.indices.contains(workoutIndex) ? exerciseDB.generatedWorkouts[workoutIndex] : exerciseDB.generatedWorkouts.first
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    if let workout = todaysWorkout {
                        TodaysWorkoutCard(
                            workout: workout,
                            showingWorkoutLog: $showingWorkoutLog,
                            showingWorkoutDetail: $showingWorkoutDetail
                        )
                    }
                    
                    WeekProgressView()
                    QuickStatsView()
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
        .sheet(isPresented: $showingWorkoutDetail) {
            if let workout = todaysWorkout {
                WorkoutDetailView(workout: workout)
            }
        }
    }
}

struct TodaysWorkoutCard: View {
    let workout: GeneratedWorkout
    @Binding var showingWorkoutLog: Bool
    @Binding var showingWorkoutDetail: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Today's Workout")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                PatternBadge(pattern: workout.primaryPattern)
            }
            
            VStack(spacing: 12) {
                // Preview Button
                Button(action: {
                    showingWorkoutDetail = true
                }) {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(workout.name)
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Text("Day \(workout.day) • \(workout.primaryPattern.rawValue) Focus")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            // Quick preview of exercises
                            HStack {
                                Text("A) \(workout.primary.name)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                                
                                Spacer()
                                
                                Image(systemName: "eye")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                            .font(.title3)
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
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
                
                // Start Workout Button
                Button(action: {
                    showingWorkoutLog = true
                }) {
                    HStack {
                        Image(systemName: "play.fill")
                            .font(.subheadline)
                        
                        Text("Start Workout")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Label("45-60 min", systemImage: "clock")
                            .font(.caption)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.purple)
                    )
                }
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 6)
    }
}

struct WeekProgressView: View {
    @EnvironmentObject var dataManager: WorkoutDataManager
    
    let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    var weeklyProgress: [Bool] {
        let calendar = Calendar.current
        let today = Date()
        let weekStart = calendar.dateInterval(of: .weekOfYear, for: today)?.start ?? today
        
        return days.enumerated().map { index, _ in
            let dayDate = calendar.date(byAdding: .day, value: index, to: weekStart) ?? today
            return dataManager.workoutSessions.contains { session in
                calendar.isDate(session.date, inSameDayAs: dayDate) && session.isCompleted
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("This Week")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("\(weeklyProgress.filter { $0 }.count)/\(days.count) days")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            HStack(spacing: 16) {
                ForEach(Array(days.enumerated()), id: \.offset) { index, day in
                    VStack(spacing: 8) {
                        Text(day)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        
                        Circle()
                            .fill(weeklyProgress[index] ? .green : .gray.opacity(0.3))
                            .frame(width: 36, height: 36)
                            .overlay(
                                Image(systemName: weeklyProgress[index] ? "checkmark" : "circle")
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
}

struct QuickStatsView: View {
    @EnvironmentObject var dataManager: WorkoutDataManager
    
    var totalWorkouts: Int {
        dataManager.workoutSessions.filter { $0.isCompleted }.count
    }
    
    var thisWeekWorkouts: Int {
        let calendar = Calendar.current
        let today = Date()
        let weekStart = calendar.dateInterval(of: .weekOfYear, for: today)?.start ?? today
        
        return dataManager.workoutSessions.filter { session in
            session.isCompleted && session.date >= weekStart
        }.count
    }
    
    var averageWorkoutTime: TimeInterval {
        let completedWorkouts = dataManager.workoutSessions.filter { $0.isCompleted }
        guard !completedWorkouts.isEmpty else { return 0 }
        
        let totalTime = completedWorkouts.reduce(0) { $0 + $1.duration }
        return totalTime / Double(completedWorkouts.count)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Stats")
                .font(.headline)
                .fontWeight(.semibold)
            
            HStack(spacing: 16) {
                StatCard(
                    title: "This Week",
                    value: "\(thisWeekWorkouts)",
                    subtitle: "workouts",
                    color: .blue
                )
                
                StatCard(
                    title: "Total",
                    value: "\(totalWorkouts)",
                    subtitle: "completed",
                    color: .green
                )
                
                StatCard(
                    title: "Avg Time",
                    value: formatDuration(averageWorkoutTime),
                    subtitle: "per workout",
                    color: .orange
                )
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 6)
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        return "\(minutes)m"
    }
}

struct QuickActionsView: View {
    @Binding var showingWorkoutLog: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            QuickActionButton(
                title: "Log Workout",
                icon: "checkmark.circle.fill",
                color: .green
            ) {
                showingWorkoutLog = true
            }
            
            QuickActionButton(
                title: "Browse Plans",
                icon: "list.clipboard",
                color: .blue
            ) {
                // TODO: Navigate to workout plans
            }
            
            QuickActionButton(
                title: "Exercise History",
                icon: "chart.line.uptrend.xyaxis",
                color: .purple
            ) {
                // TODO: Navigate to exercise browser
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
                    .multilineTextAlignment(.center)
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
