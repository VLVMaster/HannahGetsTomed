//
//  GeneratedWorkoutsView.swift
//  HannahGetsTomed
//
//  Created by Hannah Mercer on 08/07/2025.
//


//
//  GeneratedWorkoutsView.swift
//  HannahGetsTomed
//

import SwiftUI

struct GeneratedWorkoutsView: View {
    @EnvironmentObject var exerciseDB: ExerciseDatabase
    @EnvironmentObject var dataManager: WorkoutDataManager
    @State private var selectedWorkout: GeneratedWorkout?
    @State private var showingWorkoutDetail = false
    @State private var filterPattern: MovementPattern?
    
    var filteredWorkouts: [GeneratedWorkout] {
        if let pattern = filterPattern {
            return exerciseDB.generatedWorkouts.filter { $0.primaryPattern == pattern }
        }
        return exerciseDB.generatedWorkouts
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Filter Section
                filterSection
                
                // Workout List
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(filteredWorkouts) { workout in
                            WorkoutCard(workout: workout) {
                                selectedWorkout = workout
                                showingWorkoutDetail = true
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Daily Workouts")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $showingWorkoutDetail) {
            if let workout = selectedWorkout {
                WorkoutDetailView(workout: workout)
            }
        }
    }
    
    private var filterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                FilterChip(
                    title: "All",
                    isSelected: filterPattern == nil
                ) {
                    filterPattern = nil
                }
                
                FilterChip(
                    title: "Squat (\(exerciseDB.generatedWorkouts.filter { $0.primaryPattern == .squat }.count))",
                    isSelected: filterPattern == .squat
                ) {
                    filterPattern = .squat
                }
                
                FilterChip(
                    title: "Deadlift (\(exerciseDB.generatedWorkouts.filter { $0.primaryPattern == .hinge }.count))",
                    isSelected: filterPattern == .hinge
                ) {
                    filterPattern = .hinge
                }
                
                FilterChip(
                    title: "Bench (\(exerciseDB.generatedWorkouts.filter { $0.primaryPattern == .press }.count))",
                    isSelected: filterPattern == .press
                ) {
                    filterPattern = .press
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color.purple : Color(.systemBackground))
                )
                .foregroundColor(isSelected ? .white : .primary)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.purple.opacity(0.3), lineWidth: 1)
                )
        }
    }
}

struct WorkoutCard: View {
    let workout: GeneratedWorkout
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(workout.name)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Text("Day \(workout.day)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    PatternBadge(pattern: workout.primaryPattern)
                }
                
                // Workout Structure
                VStack(alignment: .leading, spacing: 8) {
                    ExerciseRow(
                        label: "A)",
                        exercise: workout.primary,
                        category: "Primary",
                        color: .purple
                    )
                    
                    ExerciseRow(
                        label: "B)",
                        exercise: workout.secondary,
                        category: "Secondary",
                        color: .blue
                    )
                    
                    HStack(spacing: 16) {
                        ExerciseRow(
                            label: "C1)",
                            exercise: workout.supersetA,
                            category: "Superset",
                            color: .green,
                            compact: true
                        )
                        
                        ExerciseRow(
                            label: "C2)",
                            exercise: workout.supersetB,
                            category: "Superset",
                            color: .green,
                            compact: true
                        )
                    }
                    
                    ExerciseRow(
                        label: "D)",
                        exercise: workout.conditioning,
                        category: "Conditioning",
                        color: .orange
                    )
                }
                
                // Stats Row
                HStack {
                    Label("45-60 min", systemImage: "clock")
                    Spacer()
                    Label("5 exercises", systemImage: "list.bullet")
                    Spacer()
                    Label(workout.primaryPattern.rawValue, systemImage: "target")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ExerciseRow: View {
    let label: String
    let exercise: Exercise
    let category: String
    let color: Color
    var compact: Bool = false
    
    var body: some View {
        HStack(spacing: 8) {
            Text(label)
                .font(compact ? .caption : .subheadline)
                .fontWeight(.semibold)
                .foregroundColor(color)
                .frame(width: compact ? 20 : 24, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(exercise.name)
                    .font(compact ? .caption : .subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                if !compact {
                    Text("\(category) • \(exercise.equipment.rawValue)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            if !compact {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct PatternBadge: View {
    let pattern: MovementPattern
    
    var patternColor: Color {
        switch pattern {
        case .squat: return .purple
        case .hinge: return .red
        case .press: return .blue
        default: return .gray
        }
    }
    
    var body: some View {
        Text(pattern.rawValue.uppercased())
            .font(.caption)
            .fontWeight(.bold)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(patternColor.opacity(0.1))
            )
            .foregroundColor(patternColor)
    }
}

// MARK: - Workout Detail View
struct WorkoutDetailView: View {
    let workout: GeneratedWorkout
    @EnvironmentObject var exerciseDB: ExerciseDatabase
    @EnvironmentObject var dataManager: WorkoutDataManager
    @Environment(\.dismiss) private var dismiss
    @State private var showingSwapOptions: Exercise?
    @State private var currentWorkout: GeneratedWorkout
    
    init(workout: GeneratedWorkout) {
        self.workout = workout
        self._currentWorkout = State(initialValue: workout)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Workout Overview
                    workoutOverview
                    
                    // Exercise Details
                    exerciseDetails
                    
                    // Start Workout Button
                    startWorkoutButton
                }
                .padding()
            }
            .navigationTitle(currentWorkout.name)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .sheet(item: $showingSwapOptions) { exercise in
            ExerciseSwapView(
                originalExercise: exercise,
                onSwap: { newExercise in
                    swapExercise(original: exercise, new: newExercise)
                }
            )
        }
    }
    
    private var workoutOverview: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                PatternBadge(pattern: currentWorkout.primaryPattern)
                Spacer()
                Text("Day \(currentWorkout.day)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Text("Workout Structure")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text("This workout follows the A) Primary + B) Secondary + C1/C2) Superset + D) Conditioning format. Each exercise can be swapped for similar movements.")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
    
    private var exerciseDetails: some View {
        VStack(spacing: 16) {
            DetailExerciseCard(
                label: "A) Primary",
                exercise: currentWorkout.primary,
                color: .purple,
                suggestion: dataManager.getSuggestedWorkout(for: currentWorkout.primary)
            ) {
                showingSwapOptions = currentWorkout.primary
            }
            
            DetailExerciseCard(
                label: "B) Secondary",
                exercise: currentWorkout.secondary,
                color: .blue,
                suggestion: dataManager.getSuggestedWorkout(for: currentWorkout.secondary)
            ) {
                showingSwapOptions = currentWorkout.secondary
            }
            
            HStack(spacing: 12) {
                DetailExerciseCard(
                    label: "C1) Superset",
                    exercise: currentWorkout.supersetA,
                    color: .green,
                    suggestion: dataManager.getSuggestedWorkout(for: currentWorkout.supersetA),
                    compact: true
                ) {
                    showingSwapOptions = currentWorkout.supersetA
                }
                
                DetailExerciseCard(
                    label: "C2) Superset",
                    exercise: currentWorkout.supersetB,
                    color: .green,
                    suggestion: dataManager.getSuggestedWorkout(for: currentWorkout.supersetB),
                    compact: true
                ) {
                    showingSwapOptions = currentWorkout.supersetB
                }
            }
            
            DetailExerciseCard(
                label: "D) Conditioning",
                exercise: currentWorkout.conditioning,
                color: .orange,
                suggestion: dataManager.getSuggestedWorkout(for: currentWorkout.conditioning)
            ) {
                showingSwapOptions = currentWorkout.conditioning
            }
        }
    }
    
    private var startWorkoutButton: some View {
        Button("Start This Workout") {
            // TODO: Navigate to workout logging with pre-filled exercises
            dismiss()
        }
        .font(.headline)
        .fontWeight(.semibold)
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.purple)
        )
    }
    
    private func swapExercise(original: Exercise, new: Exercise) {
        if currentWorkout.primary.id == original.id {
            currentWorkout.primary = new
        } else if currentWorkout.secondary.id == original.id {
            currentWorkout.secondary = new
        } else if currentWorkout.supersetA.id == original.id {
            currentWorkout.supersetA = new
        } else if currentWorkout.supersetB.id == original.id {
            currentWorkout.supersetB = new
        } else if currentWorkout.conditioning.id == original.id {
            currentWorkout.conditioning = new
        }
    }
}

struct DetailExerciseCard: View {
    let label: String
    let exercise: Exercise
    let color: Color
    let suggestion: WorkoutSuggestion
    var compact: Bool = false
    let onSwap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(label)
                    .font(compact ? .subheadline : .headline)
                    .fontWeight(.semibold)
                    .foregroundColor(color)
                
                Spacer()
                
                Button(action: onSwap) {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            Text(exercise.name)
                .font(compact ? .subheadline : .title3)
                .fontWeight(.medium)
            
            if !compact {
                HStack {
                    Label(exercise.equipment.rawValue, systemImage: "dumbbell")
                    Spacer()
                    Label(exercise.pattern.rawValue, systemImage: "target")
                }
                .font(.caption)
                .foregroundColor(.secondary)
                
                if let weight = suggestion.suggestedWeight {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Suggested:")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                        
                        Text("\(weight, specifier: "%.1f") kg × \(suggestion.suggestedReps)")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(color)
                        
                        Text(suggestion.basedOn)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding(compact ? 12 : 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color.opacity(0.2), lineWidth: 2)
                )
        )
    }
}