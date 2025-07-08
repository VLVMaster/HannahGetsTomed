//
//  WorkoutDataManager.swift
//  HannahGetsTomed
//
//  Created by Hannah Mercer on 07/07/2025.
//


// WorkoutDataManager.swift
import Foundation
import SwiftUI

class WorkoutDataManager: ObservableObject {
    @Published var workoutSessions: [WorkoutSession] = []
    @Published var workoutBlocks: [WorkoutBlock] = []
    @Published var exerciseHistory: [UUID: [WorkoutSet]] = [:]
    @Published var currentTimer: WorkoutTimer = WorkoutTimer()
    
    private let userDefaults = UserDefaults.standard
    
    init() {
        loadData()
    }
    
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
    }
    
    func addWorkoutSession(_ session: WorkoutSession) {
        workoutSessions.append(session)
        
        for exerciseLog in session.exercises {
            if exerciseHistory[exerciseLog.exerciseId] == nil {
                exerciseHistory[exerciseLog.exerciseId] = []
            }
            exerciseHistory[exerciseLog.exerciseId]?.append(contentsOf: exerciseLog.sets)
        }
        
        saveData()
    }
    
    func getExerciseHistory(for exerciseId: UUID) -> [WorkoutSet] {
        return exerciseHistory[exerciseId]?.sorted { $0.date > $1.date } ?? []
    }
    
    func getPersonalBest(for exerciseId: UUID, repRange: Int) -> WorkoutSet? {
        let history = getExerciseHistory(for: exerciseId)
        return history
            .filter { $0.reps == repRange }
            .max { $0.weight < $1.weight }
    }
    
    func addWorkoutBlock(_ block: WorkoutBlock) {
        workoutBlocks.append(block)
        saveData()
    }
    
    func deleteWorkoutBlock(_ block: WorkoutBlock) {
        workoutBlocks.removeAll { $0.id == block.id }
        saveData()
    }
}