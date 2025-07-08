//
//  MovementPattern.swift
//  HannahGetsTomed
//
//  Created by Hannah Mercer on 07/07/2025.
//


// Models.swift
import Foundation

// MARK: - Enums
enum MovementPattern: String, CaseIterable, Codable {
    case squat = "Squat"
    case hinge = "Hinge"
    case press = "Press"
    case pull = "Pull"
    case core = "Core"
    case fullBody = "Full Body"
    case cardio = "Cardio"
}

enum ExerciseCategory: String, CaseIterable, Codable {
    case primary = "Primary"
    case secondary = "Secondary"
    case accessory = "Accessory"
    case conditioning = "Conditioning"
    case warmup = "Warmup"
}

enum Equipment: String, CaseIterable, Codable {
    case barbell = "Barbell"
    case dumbbell = "Dumbbell"
    case bodyweight = "Bodyweight"
    case machine = "Machine"
    case bands = "Bands"
    case kettlebell = "Kettlebell"
    case cable = "Cable"
    case none = "None"
}

enum ConditioningFormat: String, CaseIterable, Codable {
    case emom = "EMOM"
    case forTime = "For Time"
    case amrap = "AMRAP"
    case tabata = "Tabata"
    case circuits = "Circuits"
    case intervals = "Intervals"
}

// MARK: - Core Models
struct Exercise: Identifiable, Codable, Equatable {
    let id = UUID()
    let name: String
    let pattern: MovementPattern
    let category: ExerciseCategory
    let equipment: Equipment
    
    static func == (lhs: Exercise, rhs: Exercise) -> Bool {
        lhs.id == rhs.id
    }
}

struct WorkoutSet: Identifiable, Codable {
    let id = UUID()
    var weight: Double
    var reps: Int
    var date: Date = Date()
    var notes: String = ""
}

struct ExerciseLog: Identifiable, Codable {
    let id = UUID()
    let exerciseId: UUID
    let exerciseName: String
    var sets: [WorkoutSet]
    var notes: String
    let date: Date
}

struct WorkoutSession: Identifiable, Codable {
    let id = UUID()
    let date: Date
    var exercises: [ExerciseLog]
    var duration: TimeInterval
    var generalNotes: String
    var isCompleted: Bool
}

struct WorkoutDay: Identifiable, Codable {
    let id = UUID()
    var primaryPattern: MovementPattern
    var secondaryMovement: Exercise?
    var pairedMovement: Exercise?
    var conditioning: ConditioningFormat?
    var accessoryPair: [Exercise]
    var notes: String
    var isRestDay: Bool
}

struct WorkoutBlock: Identifiable, Codable {
    let id = UUID()
    var name: String
    var weeks: [[WorkoutDay]]
    var currentWeek: Int
    var repRanges: [String: String]
}