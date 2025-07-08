//
//  ExerciseSwapView.swift & ExerciseHistoryView.swift
//  HannahGetsTomed
//

import SwiftUI
import Charts

// MARK: - Exercise Swap View
struct ExerciseSwapView: View {
    let originalExercise: Exercise
    let onSwap: (Exercise) -> Void
    
    @EnvironmentObject var exerciseDB: ExerciseDatabase
    @EnvironmentObject var dataManager: WorkoutDataManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedCategory: ExerciseCategory?
    @State private var selectedEquipment: Equipment?
    @State private var searchText = ""
    
    var filteredExercises: [Exercise] {
        var exercises = exerciseDB.getSwapOptions(for: originalExercise)
        
        if let category = selectedCategory {
            exercises = exercises.filter { $0.category == category }
        }
        
        if let equipment = selectedEquipment {
            exercises = exercises.filter { $0.equipment == equipment }
        }
        
        if !searchText.isEmpty {
            exercises = exercises.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        return exercises
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Current Exercise
                currentExerciseSection
                
                // Filters
                filtersSection
                
                // Search
                searchSection
                
                // Exercise List
                exerciseListSection
            }
            .navigationTitle("Swap Exercise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var currentExerciseSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Currently Selected")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(originalExercise.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("\(originalExercise.category.rawValue) • \(originalExercise.equipment.rawValue)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                PatternBadge(pattern: originalExercise.pattern)
            }
        }
        .padding()
        .background(Color(.systemGray6))
    }
    
    private var filtersSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                // Category filters
                ForEach(ExerciseCategory.allCases, id: \.self) { category in
                    FilterChip(
                        title: category.rawValue,
                        isSelected: selectedCategory == category
                    ) {
                        selectedCategory = selectedCategory == category ? nil : category
                    }
                }
                
                Divider()
                    .frame(height: 20)
                
                // Equipment filters
                ForEach(Equipment.allCases, id: \.self) { equipment in
                    FilterChip(
                        title: equipment.rawValue,
                        isSelected: selectedEquipment == equipment
                    ) {
                        selectedEquipment = selectedEquipment == equipment ? nil : equipment
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
    }
    
    private var searchSection: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search exercises...", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
        }
        .padding()
        .background(Color(.systemGray6))
    }
    
    private var exerciseListSection: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(filteredExercises) { exercise in
                    SwapExerciseRow(
                        exercise: exercise,
                        lastUsed: dataManager.getLastWorkout(for: exercise.id)?.date,
                        pb: dataManager.getPersonalBest(for: exercise.id, repRange: 5)
                    ) {
                        onSwap(exercise)
                        dismiss()
                    }
                }
            }
            .padding()
        }
    }
}

struct SwapExerciseRow: View {
    let exercise: Exercise
    let lastUsed: Date?
    let pb: WorkoutSet?
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(exercise.name)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    HStack {
                        Text(exercise.equipment.rawValue)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        if let lastUsed = lastUsed {
                            Text("• Last used \(lastUsed, formatter: DateFormatter.shortDate)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    if let pb = pb {
                        Text(String(format: "%.1f kg", pb.weight))
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.purple)
                        
                        Text("5RM PB")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemBackground))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Exercise History View
struct ExerciseHistoryView: View {
    let exercise: Exercise
    @EnvironmentObject var dataManager: WorkoutDataManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedPeriod: TimePeriod = .allTime
    @State private var showingAddSet = false
    
    var exerciseHistory: [WorkoutSet] {
        dataManager.getExerciseHistory(for: exercise.id)
    }
    
    var filteredHistory: [WorkoutSet] {
        let now = Date()
        let calendar = Calendar.current
        
        switch selectedPeriod {
        case .week:
            let weekAgo = calendar.date(byAdding: .day, value: -7, to: now)!
            return exerciseHistory.filter { $0.date >= weekAgo }
        case .month:
            let monthAgo = calendar.date(byAdding: .month, value: -1, to: now)!
            return exerciseHistory.filter { $0.date >= monthAgo }
        case .threeMonths:
            let threeMonthsAgo = calendar.date(byAdding: .month, value: -3, to: now)!
            return exerciseHistory.filter { $0.date >= threeMonthsAgo }
        case .allTime:
            return exerciseHistory
        }
    }
    
    var personalBests: [String: WorkoutSet] {
        dataManager.getPersonalBests(for: exercise.id)
    }
    
    var analytics: ExerciseAnalytics? {
        dataManager.exerciseAnalytics[exercise.id]
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Exercise Info
                    exerciseInfoSection
                    
                    // Stats Overview
                    statsOverviewSection
                    
                    // Personal Bests
                    personalBestsSection
                    
                    // Progress Chart
                    if !filteredHistory.isEmpty {
                        progressChartSection
                    }
                    
                    // History List
                    historyListSection
                }
                .padding()
            }
            .navigationTitle(exercise.name)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddSet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddSet) {
            AddSetView(exercise: exercise)
        }
    }
    
    private var exerciseInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(exercise.name)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("\(exercise.category.rawValue) • \(exercise.equipment.rawValue)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                PatternBadge(pattern: exercise.pattern)
            }
            
            // Period Selector
            Picker("Time Period", selection: $selectedPeriod) {
                ForEach(TimePeriod.allCases, id: \.self) { period in
                    Text(period.rawValue).tag(period)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
    
    private var statsOverviewSection: some View {
        HStack(spacing: 16) {
            StatCard(
                title: "Sessions",
                value: "\(dataManager.getSessionCount(for: exercise.id, period: selectedPeriod))",
                subtitle: selectedPeriod.rawValue,
                color: .blue
            )
            
            StatCard(
                title: "Total Volume",
                value: String(format: "%.0f kg", dataManager.getTotalVolume(for: exercise.id, period: selectedPeriod)),
                subtitle: selectedPeriod.rawValue,
                color: .green
            )
            
            if let analytics = analytics, let avgRPE = analytics.averageRPE {
                StatCard(
                    title: "Avg RPE",
                    value: String(format: "%.1f", avgRPE),
                    subtitle: "All Time",
                    color: .orange
                )
            }
        }
    }
    
    private var personalBestsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Personal Bests")
                .font(.headline)
                .fontWeight(.semibold)
            
            if personalBests.isEmpty {
                Text("No personal bests recorded yet")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 12) {
                    ForEach(Array(personalBests.keys.sorted()), id: \.self) { key in
                        if let pb = personalBests[key] {
                            PersonalBestCard(repMax: key, set: pb)
                        }
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
    
    @available(iOS 16.0, *)
    private var progressChartSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Progress Trend")
                .font(.headline)
                .fontWeight(.semibold)
            
            Chart(filteredHistory.suffix(20)) { set in
                LineMark(
                    x: .value("Date", set.date),
                    y: .value("Weight", set.weight)
                )
                .foregroundStyle(.purple)
                
                PointMark(
                    x: .value("Date", set.date),
                    y: .value("Weight", set.weight)
                )
                .foregroundStyle(.purple)
            }
            .frame(height: 200)
            .chartXAxis {
                AxisMarks(values: .stride(by: .day, count: 7)) { value in
                    AxisGridLine()
                    AxisValueLabel(format: .dateTime.month().day())
                }
            }
            .chartYAxis {
                AxisMarks { value in
                    AxisGridLine()
                    AxisValueLabel()
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
    
    private var historyListSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent History")
                .font(.headline)
                .fontWeight(.semibold)
            
            if filteredHistory.isEmpty {
                Text("No history for selected period")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                ForEach(Array(filteredHistory.prefix(20).enumerated()), id: \.offset) { index, set in
                    HistorySetRow(set: set, isRecent: index < 5)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(subtitle)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemBackground))
        )
    }
}

struct PersonalBestCard: View {
    let repMax: String
    let set: WorkoutSet
    
    var body: some View {
        VStack(spacing: 6) {
            Text(repMax)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            
            Text(String(format: "%.1f kg", set.weight))
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.purple)
            
            Text(set.date, formatter: DateFormatter.shortDate)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.purple.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct HistorySetRow: View {
    let set: WorkoutSet
    let isRecent: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(String(format: "%.1f kg × %d", set.weight, set.reps))
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    if let rpe = set.rpe {
                        Text("RPE \(rpe)")
                            .font(.caption)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.orange.opacity(0.2))
                            )
                            .foregroundColor(.orange)
                    }
                    
                    if set.personalBest {
                        Text("PB")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.purple.opacity(0.2))
                            )
                            .foregroundColor(.purple)
                    }
                }
                
                if !set.notes.isEmpty {
                    Text(set.notes)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text(set.date, formatter: DateFormatter.shortDate)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                if isRecent {
                    Text("Recent")
                        .font(.caption2)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 1)
                        .background(
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color.green.opacity(0.2))
                        )
                        .foregroundColor(.green)
                }
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemBackground))
        )
    }
}

// MARK: - Add Set View
struct AddSetView: View {
    let exercise: Exercise
    @EnvironmentObject var dataManager: WorkoutDataManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var weight: Double = 0
    @State private var reps: Int = 5
    @State private var rpe: Int = 7
    @State private var notes: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("Set Details") {
                    HStack {
                        Text("Weight")
                        Spacer()
                        TextField("Weight", value: $weight, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                        Text("kg")
                    }
                    
                    HStack {
                        Text("Reps")
                        Spacer()
                        TextField("Reps", value: $reps, format: .number)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("RPE")
                        Spacer()
                        Picker("RPE", selection: $rpe) {
                            ForEach(1...10, id: \.self) { value in
                                Text("\(value)").tag(value)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                }
                
                Section("Notes") {
                    TextField("Optional notes...", text: $notes, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
                }
            }
            .navigationTitle("Add Set")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveSet()
                    }
                    .disabled(weight <= 0 || reps <= 0)
                }
            }
        }
        .onAppear {
            // Pre-fill with suggestion if available
            let suggestion = dataManager.getSuggestedWorkout(for: exercise)
            if let suggestedWeight = suggestion.suggestedWeight {
                weight = suggestedWeight
            }
        }
    }
    
    private func saveSet() {
        let newSet = WorkoutSet(
            weight: weight,
            reps: reps,
            rpe: rpe,
            date: Date(),
            notes: notes
        )
        
        // Add to exercise history
        if dataManager.exerciseHistory[exercise.id] == nil {
            dataManager.exerciseHistory[exercise.id] = []
        }
        dataManager.exerciseHistory[exercise.id]?.append(newSet)
        
        dataManager.saveData()
        dismiss()
    }
}
