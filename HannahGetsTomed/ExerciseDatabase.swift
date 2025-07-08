//
//  ExerciseDatabase.swift
//  HannahGetsTomed
//

import Foundation
import SwiftUI

class ExerciseDatabase: ObservableObject {
    let exercises: [Exercise] = [
        // SQUAT PRIMARY PATTERNS (10)
        Exercise(name: "Back Squat", pattern: .squat, category: .primary, equipment: .barbell),
        Exercise(name: "Front Squat", pattern: .squat, category: .primary, equipment: .barbell),
        Exercise(name: "Goblet Squat", pattern: .squat, category: .primary, equipment: .dumbbell),
        Exercise(name: "Bulgarian Split Squat", pattern: .squat, category: .primary, equipment: .dumbbell),
        Exercise(name: "Zercher Squat", pattern: .squat, category: .primary, equipment: .barbell),
        Exercise(name: "Safety Bar Squat", pattern: .squat, category: .primary, equipment: .barbell),
        Exercise(name: "Box Squat", pattern: .squat, category: .primary, equipment: .barbell),
        Exercise(name: "Overhead Squat", pattern: .squat, category: .primary, equipment: .barbell),
        Exercise(name: "Hack Squat", pattern: .squat, category: .primary, equipment: .machine),
        Exercise(name: "Leg Press", pattern: .squat, category: .primary, equipment: .machine),
        
        // HINGE PRIMARY PATTERNS (15 - Deadlift/RDL)
        Exercise(name: "Conventional Deadlift", pattern: .hinge, category: .primary, equipment: .barbell),
        Exercise(name: "Romanian Deadlift", pattern: .hinge, category: .primary, equipment: .barbell),
        Exercise(name: "Sumo Deadlift", pattern: .hinge, category: .primary, equipment: .barbell),
        Exercise(name: "Trap Bar Deadlift", pattern: .hinge, category: .primary, equipment: .barbell),
        Exercise(name: "Single Leg RDL", pattern: .hinge, category: .primary, equipment: .dumbbell),
        Exercise(name: "Stiff Leg Deadlift", pattern: .hinge, category: .primary, equipment: .barbell),
        Exercise(name: "Deficit Deadlift", pattern: .hinge, category: .primary, equipment: .barbell),
        Exercise(name: "Rack Pull", pattern: .hinge, category: .primary, equipment: .barbell),
        Exercise(name: "Good Morning", pattern: .hinge, category: .primary, equipment: .barbell),
        Exercise(name: "Kettlebell Deadlift", pattern: .hinge, category: .primary, equipment: .kettlebell),
        Exercise(name: "Dumbbell RDL", pattern: .hinge, category: .primary, equipment: .dumbbell),
        Exercise(name: "Cable RDL", pattern: .hinge, category: .primary, equipment: .cable),
        Exercise(name: "B-Stance RDL", pattern: .hinge, category: .primary, equipment: .dumbbell),
        Exercise(name: "Landmine RDL", pattern: .hinge, category: .primary, equipment: .barbell),
        Exercise(name: "Banded RDL", pattern: .hinge, category: .primary, equipment: .bands),
        
        // PRESS PRIMARY PATTERNS (15 - Bench Press variations)
        Exercise(name: "Barbell Bench Press", pattern: .press, category: .primary, equipment: .barbell),
        Exercise(name: "Dumbbell Bench Press", pattern: .press, category: .primary, equipment: .dumbbell),
        Exercise(name: "Incline Bench Press", pattern: .press, category: .primary, equipment: .barbell),
        Exercise(name: "Decline Bench Press", pattern: .press, category: .primary, equipment: .barbell),
        Exercise(name: "Close Grip Bench", pattern: .press, category: .primary, equipment: .barbell),
        Exercise(name: "Incline Dumbbell Press", pattern: .press, category: .primary, equipment: .dumbbell),
        Exercise(name: "Floor Press", pattern: .press, category: .primary, equipment: .barbell),
        Exercise(name: "Dumbbell Floor Press", pattern: .press, category: .primary, equipment: .dumbbell),
        Exercise(name: "Overhead Press", pattern: .press, category: .primary, equipment: .barbell),
        Exercise(name: "Push Press", pattern: .press, category: .primary, equipment: .barbell),
        Exercise(name: "Dumbbell Shoulder Press", pattern: .press, category: .primary, equipment: .dumbbell),
        Exercise(name: "Machine Press", pattern: .press, category: .primary, equipment: .machine),
        Exercise(name: "Landmine Press", pattern: .press, category: .primary, equipment: .barbell),
        Exercise(name: "Single Arm Press", pattern: .press, category: .primary, equipment: .dumbbell),
        Exercise(name: "Z Press", pattern: .press, category: .primary, equipment: .barbell),
        
        // SECONDARY EXERCISES
        Exercise(name: "Bent Over Row", pattern: .pull, category: .secondary, equipment: .barbell),
        Exercise(name: "Pull-ups", pattern: .pull, category: .secondary, equipment: .bodyweight),
        Exercise(name: "Chin-ups", pattern: .pull, category: .secondary, equipment: .bodyweight),
        Exercise(name: "T-Bar Row", pattern: .pull, category: .secondary, equipment: .barbell),
        Exercise(name: "Dumbbell Row", pattern: .pull, category: .secondary, equipment: .dumbbell),
        Exercise(name: "Seated Cable Row", pattern: .pull, category: .secondary, equipment: .cable),
        Exercise(name: "Lat Pulldown", pattern: .pull, category: .secondary, equipment: .machine),
        Exercise(name: "Dips", pattern: .press, category: .secondary, equipment: .bodyweight),
        Exercise(name: "Push-ups", pattern: .press, category: .secondary, equipment: .bodyweight),
        Exercise(name: "Walking Lunges", pattern: .squat, category: .secondary, equipment: .dumbbell),
        Exercise(name: "Step-ups", pattern: .squat, category: .secondary, equipment: .dumbbell),
        Exercise(name: "Hip Thrust", pattern: .hinge, category: .secondary, equipment: .barbell),
        Exercise(name: "Glute Bridge", pattern: .hinge, category: .secondary, equipment: .bodyweight),
        
        // ACCESSORY EXERCISES
        Exercise(name: "Lateral Raises", pattern: .press, category: .accessory, equipment: .dumbbell),
        Exercise(name: "Bicep Curls", pattern: .pull, category: .accessory, equipment: .dumbbell),
        Exercise(name: "Tricep Extensions", pattern: .press, category: .accessory, equipment: .dumbbell),
        Exercise(name: "Face Pulls", pattern: .pull, category: .accessory, equipment: .bands),
        Exercise(name: "Leg Curls", pattern: .hinge, category: .accessory, equipment: .machine),
        Exercise(name: "Leg Extensions", pattern: .squat, category: .accessory, equipment: .machine),
        Exercise(name: "Calf Raises", pattern: .squat, category: .accessory, equipment: .bodyweight),
        Exercise(name: "Shrugs", pattern: .pull, category: .accessory, equipment: .dumbbell),
        Exercise(name: "Hammer Curls", pattern: .pull, category: .accessory, equipment: .dumbbell),
        Exercise(name: "Tricep Dips", pattern: .press, category: .accessory, equipment: .bodyweight),
        Exercise(name: "Cable Flyes", pattern: .press, category: .accessory, equipment: .cable),
        Exercise(name: "Rear Delt Flyes", pattern: .pull, category: .accessory, equipment: .dumbbell),
        
        // CONDITIONING
        Exercise(name: "Kettlebell Swings", pattern: .fullBody, category: .conditioning, equipment: .kettlebell),
        Exercise(name: "Burpees", pattern: .fullBody, category: .conditioning, equipment: .bodyweight),
        Exercise(name: "Mountain Climbers", pattern: .fullBody, category: .conditioning, equipment: .bodyweight),
        Exercise(name: "Battle Ropes", pattern: .fullBody, category: .conditioning, equipment: .bands),
        Exercise(name: "Box Jumps", pattern: .squat, category: .conditioning, equipment: .bodyweight),
        Exercise(name: "Plank", pattern: .core, category: .accessory, equipment: .bodyweight),
        Exercise(name: "Dead Bug", pattern: .core, category: .accessory, equipment: .bodyweight),
    ]
    
    @Published var generatedWorkouts: [GeneratedWorkout] = []
    
    init() {
        generateDailyWorkouts()
    }
    
    func generateDailyWorkouts() {
        let squatPrimaries = getExercises(by: .squat, category: .primary)
        let hingePrimaries = getExercises(by: .hinge, category: .primary)
        let pressPrimaries = getExercises(by: .press, category: .primary)
        
        var workouts: [GeneratedWorkout] = []
        
        // Generate 10 squat days
        for i in 0..<10 {
            let primary = squatPrimaries[i % squatPrimaries.count]
            let secondary = getComplementarySecondary(for: .squat)
            let supersetPair = generateSupersetPair()
            let conditioning = getRandomConditioning()
            
            workouts.append(GeneratedWorkout(
                id: UUID(),
                day: i + 1,
                name: "Squat Day \(i + 1)",
                primaryPattern: .squat,
                primary: primary,
                secondary: secondary,
                supersetA: supersetPair.0,
                supersetB: supersetPair.1,
                conditioning: conditioning
            ))
        }
        
        // Generate 15 hinge days (deadlift/RDL)
        for i in 0..<15 {
            let primary = hingePrimaries[i % hingePrimaries.count]
            let secondary = getComplementarySecondary(for: .hinge)
            let supersetPair = generateSupersetPair()
            let conditioning = getRandomConditioning()
            
            workouts.append(GeneratedWorkout(
                id: UUID(),
                day: i + 11,
                name: "Deadlift/RDL Day \(i + 1)",
                primaryPattern: .hinge,
                primary: primary,
                secondary: secondary,
                supersetA: supersetPair.0,
                supersetB: supersetPair.1,
                conditioning: conditioning
            ))
        }
        
        // Generate 15 press days (bench press)
        for i in 0..<15 {
            let primary = pressPrimaries[i % pressPrimaries.count]
            let secondary = getComplementarySecondary(for: .press)
            let supersetPair = generateSupersetPair()
            let conditioning = getRandomConditioning()
            
            workouts.append(GeneratedWorkout(
                id: UUID(),
                day: i + 26,
                name: "Bench Press Day \(i + 1)",
                primaryPattern: .press,
                primary: primary,
                secondary: secondary,
                supersetA: supersetPair.0,
                supersetB: supersetPair.1,
                conditioning: conditioning
            ))
        }
        
        generatedWorkouts = workouts
    }
    
    func getExercises(by pattern: MovementPattern? = nil, category: ExerciseCategory? = nil, equipment: Equipment? = nil) -> [Exercise] {
        var filtered = exercises
        
        if let pattern = pattern {
            filtered = filtered.filter { $0.pattern == pattern }
        }
        
        if let category = category {
            filtered = filtered.filter { $0.category == category }
        }
        
        if let equipment = equipment {
            filtered = filtered.filter { $0.equipment == equipment }
        }
        
        return filtered.sorted { $0.name < $1.name }
    }
    
    func getExercise(by id: UUID) -> Exercise? {
        return exercises.first { $0.id == id }
    }
    
    private func getComplementarySecondary(for primaryPattern: MovementPattern) -> Exercise {
        let secondaries = getExercises(category: .secondary)
        
        switch primaryPattern {
        case .squat:
            return secondaries.filter { $0.pattern == .press }.randomElement() ?? secondaries.first!
        case .hinge:
            return secondaries.filter { $0.pattern == .pull }.randomElement() ?? secondaries.first!
        case .press:
            return secondaries.filter { $0.pattern == .pull }.randomElement() ?? secondaries.first!
        default:
            return secondaries.randomElement()!
        }
    }
    
    private func generateSupersetPair() -> (Exercise, Exercise) {
        let accessories = getExercises(category: .accessory)
        let first = accessories.randomElement()!
        let second = accessories.filter { $0.pattern != first.pattern }.randomElement() ?? accessories.first!
        return (first, second)
    }
    
    private func getRandomConditioning() -> Exercise {
        let conditioning = getExercises(category: .conditioning)
        return conditioning.randomElement()!
    }
    
    func getSwapOptions(for exercise: Exercise) -> [Exercise] {
        return getExercises(by: exercise.pattern, category: exercise.category)
            .filter { $0.id != exercise.id }
    }
}
