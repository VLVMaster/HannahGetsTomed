//
//  ExerciseDatabase.swift
//  HannahGetsTomed
//
//  Created by Hannah Mercer on 07/07/2025.
//


// ExerciseDatabase.swift
import Foundation
import SwiftUI

class ExerciseDatabase: ObservableObject {
    let exercises: [Exercise] = [
        // Squat Pattern
        Exercise(name: "Back Squat", pattern: .squat, category: .primary, equipment: .barbell),
        Exercise(name: "Front Squat", pattern: .squat, category: .primary, equipment: .barbell),
        Exercise(name: "Goblet Squat", pattern: .squat, category: .primary, equipment: .dumbbell),
        Exercise(name: "Bulgarian Split Squat", pattern: .squat, category: .secondary, equipment: .dumbbell),
        Exercise(name: "Leg Press", pattern: .squat, category: .secondary, equipment: .machine),
        Exercise(name: "Walking Lunges", pattern: .squat, category: .secondary, equipment: .dumbbell),
        Exercise(name: "Leg Extensions", pattern: .squat, category: .accessory, equipment: .machine),
        Exercise(name: "Wall Sits", pattern: .squat, category: .accessory, equipment: .bodyweight),
        
        // Hinge Pattern
        Exercise(name: "Deadlift", pattern: .hinge, category: .primary, equipment: .barbell),
        Exercise(name: "Romanian Deadlift", pattern: .hinge, category: .primary, equipment: .barbell),
        Exercise(name: "Hip Thrusts", pattern: .hinge, category: .secondary, equipment: .dumbbell),
        Exercise(name: "Glute Bridges", pattern: .hinge, category: .secondary, equipment: .bodyweight),
        Exercise(name: "Leg Curls", pattern: .hinge, category: .accessory, equipment: .machine),
        
        // Press Pattern
        Exercise(name: "Bench Press", pattern: .press, category: .primary, equipment: .barbell),
        Exercise(name: "Overhead Press", pattern: .press, category: .primary, equipment: .barbell),
        Exercise(name: "Dumbbell Press", pattern: .press, category: .secondary, equipment: .dumbbell),
        Exercise(name: "Push-ups", pattern: .press, category: .secondary, equipment: .bodyweight),
        Exercise(name: "Lateral Raises", pattern: .press, category: .accessory, equipment: .dumbbell),
        Exercise(name: "Tricep Extensions", pattern: .press, category: .accessory, equipment: .dumbbell),
        
        // Pull Pattern
        Exercise(name: "Pull-ups", pattern: .pull, category: .primary, equipment: .bodyweight),
        Exercise(name: "Bent Over Rows", pattern: .pull, category: .primary, equipment: .barbell),
        Exercise(name: "Lat Pulldowns", pattern: .pull, category: .secondary, equipment: .machine),
        Exercise(name: "Face Pulls", pattern: .pull, category: .accessory, equipment: .cable),
        Exercise(name: "Bicep Curls", pattern: .pull, category: .accessory, equipment: .dumbbell),
        
        // Core
        Exercise(name: "Planks", pattern: .core, category: .accessory, equipment: .bodyweight),
        Exercise(name: "Dead Bugs", pattern: .core, category: .accessory, equipment: .bodyweight),
        Exercise(name: "Pallof Press", pattern: .core, category: .accessory, equipment: .bands),
        
        // Conditioning
        Exercise(name: "Burpees", pattern: .cardio, category: .conditioning, equipment: .bodyweight),
        Exercise(name: "Kettlebell Swings", pattern: .cardio, category: .conditioning, equipment: .kettlebell),
        Exercise(name: "Mountain Climbers", pattern: .cardio, category: .conditioning, equipment: .bodyweight)
    ]
    
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
}
