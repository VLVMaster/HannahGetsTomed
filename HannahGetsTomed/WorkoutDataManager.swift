//
//  WorkoutDataManager.swift
//  HannahGetsTomed
//

import Foundation
import SwiftUI

class WorkoutDataManager: ObservableObject {
    @Published var workoutSessions: [WorkoutSession] = []
    @Published var workoutBlocks: [WorkoutBlock] = []
    @Published var exerciseHistory: [UUID: [WorkoutSet]] = [:]
    @Published var exerciseAnalytics: [UUID: ExerciseAnalytics] = [:]
    @Published var currentTimer: WorkoutTimer = WorkoutTimer()
    
    private let userDefaults = UserDefaults.standard
    
    init() {
        loadData()
        generateAnalytics()
    }
    
    // MARK: - Data Persistence
    func saveData() {
        if let encoded = try? JSONEncoder().encode(workoutSessions) {
            userDefaults.set(encoded, forKey: "workoutSessions")
        }
        if let encoded = try? JSONEncoder().encode(workoutBlocks) {
            userDefaults.set(encoded, forKey: "workoutBlocks")
        }
        if let encoded = try? JSONEncoder().encode(exerciseHistory) {
            userDefaults.set(encoded, forKey: "exerciseHistory")
        }
        if let encoded = try? JSONEncoder().encode(exerciseAnalytics) {
            userDefaults.set(encoded, forKey: "exerciseAnalytics")
        }
    }
    
    func loadData() {
        if let data = userDefaults.data(forKey: "workoutSessions"),
           let decoded = try? JSONDecoder().decode([WorkoutSession].self, from: data) {
            workoutSessions = decoded
        }
        
        if let data = userDefaults.data(forKey: "workoutBlocks"),
           let decoded = try? JSONDecoder().decode([WorkoutBlock].self, from: data) {
            workoutBlocks = decoded
        }
        
        if let data = userDefaults.data(forKey: "exerciseHistory"),
           let decoded = try? JSONDecoder().decode([UUID: [WorkoutSet]].self, from: data) {
            exerciseHistory = decoded
        }
        
        if let data = userDefaults.data(forKey: "exerciseAnalytics"),
           let decoded = try? JSONDecoder().decode([UUID: ExerciseAnalytics].self, from: data) {
            exerciseAnalytics = decoded
        }
    }
    
    // MARK: - Workout Session Management
    func addWorkoutSession(_ session: WorkoutSession) {
        workoutSessions.append(session)
        
        // Update exercise history
        for exerciseLog in session.exercises {
            if exerciseHistory[exerciseLog.exerciseId] == nil {
                exerciseHistory[exerciseLog.exerciseId] = []
            }
            exerciseHistory[exerciseLog.exerciseId]?.append(contentsOf: exerciseLog.sets)
        }
        
        // Update analytics
        updateAnalytics(from: session)
        saveData()
    }
    
    // MARK: - Exercise History & Analytics
    func getExerciseHistory(for exerciseId: UUID) -> [WorkoutSet] {
        return exerciseHistory[exerciseId]?.sorted { $0.date > $1.date } ?? []
    }
    
    func getExerciseHistory(for exerciseId: UUID, limit: Int) -> [WorkoutSet] {
        let history = getExerciseHistory(for: exerciseId)
        return Array(history.prefix(limit))
    }
    
    func getPersonalBest(for exerciseId: UUID, repRange: Int) -> WorkoutSet? {
        let history = getExerciseHistory(for: exerciseId)
        return history
            .filter { $0.reps == repRange }
            .max { $0.weight < $1.weight }
    }
    
    func getPersonalBests(for exerciseId: UUID) -> [String: WorkoutSet] {
        let history = getExerciseHistory(for: exerciseId)
        var pbs: [String: WorkoutSet] = [:]
        
        // Common rep ranges
        let repRanges = [1, 3, 5, 8, 10, 12, 15]
        
        for reps in repRanges {
            if let pb = history.filter({ $0.reps == reps }).max(by: { $0.weight < $1.weight }) {
                pbs["\(reps)RM"] = pb
            }
        }
        
        return pbs
    }
    
    func getLastWorkout(for exerciseId: UUID) -> ExerciseLog? {
        return workoutSessions
            .sorted { $0.date > $1.date }
            .first { session in
                session.exercises.contains { $0.exerciseId == exerciseId }
            }?.exercises.first { $0.exerciseId == exerciseId }
    }
    
    // MARK: - Auto-fill Suggestions
    func getSuggestedWorkout(for exercise: Exercise) -> WorkoutSuggestion {
        guard let lastWorkout = getLastWorkout(for: exercise.id) else {
            return WorkoutSuggestion(
                suggestedWeight: nil,
                suggestedReps: "3x5",
                suggestedRPE: 7,
                basedOn: "Default starting point"
            )
        }
        
        let lastSets = lastWorkout.sets
        let avgWeight = lastSets.reduce(0) { $0 + $1.weight } / Double(lastSets.count)
        let avgReps = lastSets.reduce(0) { $0 + $1.reps } / lastSets.count
        let avgRPE = lastSets.compactMap { $0.rpe }.reduce(0, +) / lastSets.compactMap { $0.rpe }.count
        
        // Progressive overload logic
        var suggestedWeight = avgWeight
        var suggestedRPE = avgRPE
        
        if avgRPE <= 7 {
            // If last workout was easy, increase weight
            suggestedWeight += 2.5
        } else if avgRPE >= 9 {
            // If last workout was very hard, decrease weight
            suggestedWeight -= 2.5
        }
        
        return WorkoutSuggestion(
            suggestedWeight: suggestedWeight,
            suggestedReps: "\(lastSets.count)x\(avgReps)",
            suggestedRPE: min(max(suggestedRPE, 6), 9),
            basedOn: "Last session on \(DateFormatter.shortDate.string(from: lastWorkout.date))"
        )
    }
    
    // MARK: - Analytics Generation
    private func updateAnalytics(from session: WorkoutSession) {
        for exerciseLog in session.exercises {
            let exerciseId = exerciseLog.exerciseId
            
            if exerciseAnalytics[exerciseId] == nil {
                exerciseAnalytics[exerciseId] = ExerciseAnalytics(
                    exerciseId: exerciseId,
                    totalSessions: 0,
                    totalVolume: 0,
                    personalBests: [:],
                    progressTrend: .insufficient
                )
            }
            
            var analytics = exerciseAnalytics[exerciseId]!
            analytics.totalSessions += 1
            analytics.lastUsed = session.date
            
            // Calculate volume (weight x reps x sets)
            let sessionVolume = exerciseLog.sets.reduce(0) { total, set in
                total + (set.weight * Double(set.reps))
            }
            analytics.totalVolume += sessionVolume
            
            // Update personal bests
            for set in exerciseLog.sets {
                let key = "\(set.reps)RM"
                if let currentPB = analytics.personalBests[key] {
                    if set.weight > currentPB.weight {
                        var newPB = set
                        newPB.personalBest = true
                        analytics.personalBests[key] = newPB
                    }
                } else {
                    var newPB = set
                    newPB.personalBest = true
                    analytics.personalBests[key] = newPB
                }
            }
            
            // Calculate average RPE
            let allRPEs = getExerciseHistory(for: exerciseId).compactMap { $0.rpe }
            if !allRPEs.isEmpty {
                analytics.averageRPE = Double(allRPEs.reduce(0, +)) / Double(allRPEs.count)
            }
            
            // Determine progress trend
            analytics.progressTrend = calculateProgressTrend(for: exerciseId)
            
            exerciseAnalytics[exerciseId] = analytics
        }
    }
    
    private func generateAnalytics() {
        for session in workoutSessions {
            updateAnalytics(from: session)
        }
    }
    
    private func calculateProgressTrend(for exerciseId: UUID) -> ProgressTrend {
        let recentHistory = getExerciseHistory(for: exerciseId, limit: 10)
        
        if recentHistory.count < 3 {
            return .insufficient
        }
        
        let recentWeights = recentHistory.map { $0.weight }
        let isImproving = recentWeights.enumerated().allSatisfy { index, weight in
            index == 0 || weight >= recentWeights[index - 1]
        }
        
        let weightVariation = (recentWeights.max() ?? 0) - (recentWeights.min() ?? 0)
        
        if isImproving && weightVariation > 5.0 {
            return .improving
        } else if weightVariation < 2.5 {
            return .plateaued
        } else {
            return .declining
        }
    }
    
    // MARK: - Workout Block Management
    func addWorkoutBlock(_ block: WorkoutBlock) {
        workoutBlocks.append(block)
        saveData()
    }
    
    func deleteWorkoutBlock(_ block: WorkoutBlock) {
        workoutBlocks.removeAll { $0.id == block.id }
        saveData()
    }
    
    // MARK: - Exercise Statistics
    func getTotalVolume(for exerciseId: UUID, period: TimePeriod = .allTime) -> Double {
        let history = getExerciseHistory(for: exerciseId)
        let filteredHistory = filterByPeriod(history, period: period)
        
        return filteredHistory.reduce(0) { total, set in
            total + (set.weight * Double(set.reps))
        }
    }
    
    func getSessionCount(for exerciseId: UUID, period: TimePeriod = .allTime) -> Int {
        let sessions = workoutSessions.filter { session in
            session.exercises.contains { $0.exerciseId == exerciseId }
        }
        
        return filterSessionsByPeriod(sessions, period: period).count
    }
    
    private func filterByPeriod(_ sets: [WorkoutSet], period: TimePeriod) -> [WorkoutSet] {
        let now = Date()
        let calendar = Calendar.current
        
        switch period {
        case .week:
            let weekAgo = calendar.date(byAdding: .day, value: -7, to: now)!
            return sets.filter { $0.date >= weekAgo }
        case .month:
            let monthAgo = calendar.date(byAdding: .month, value: -1, to: now)!
            return sets.filter { $0.date >= monthAgo }
        case .threeMonths:
            let threeMonthsAgo = calendar.date(byAdding: .month, value: -3, to: now)!
            return sets.filter { $0.date >= threeMonthsAgo }
        case .allTime:
            return sets
        }
    }
    
    private func filterSessionsByPeriod(_ sessions: [WorkoutSession], period: TimePeriod) -> [WorkoutSession] {
        let now = Date()
        let calendar = Calendar.current
        
        switch period {
        case .week:
            let weekAgo = calendar.date(byAdding: .day, value: -7, to: now)!
            return sessions.filter { $0.date >= weekAgo }
        case .month:
            let monthAgo = calendar.date(byAdding: .month, value: -1, to: now)!
            return sessions.filter { $0.date >= monthAgo }
        case .threeMonths:
            let threeMonthsAgo = calendar.date(byAdding: .month, value: -3, to: now)!
            return sessions.filter { $0.date >= threeMonthsAgo }
        case .allTime:
            return sessions
        }
    }
}

// MARK: - Supporting Enums
enum TimePeriod: String, CaseIterable {
    case week = "7 Days"
    case month = "30 Days"
    case threeMonths = "3 Months"
    case allTime = "All Time"
}

// MARK: - Date Formatter Extensions
extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
}
