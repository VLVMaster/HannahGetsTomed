//
//  Models.swift
//  HannahGetsTomed
//

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
    var rpe: Int? // Rate of Perceived Exertion
    var date: Date = Date()
    var notes: String = ""
    var restTime: TimeInterval? // Rest time in seconds
    var personalBest: Bool = false
}

struct ExerciseLog: Identifiable, Codable {
    let id = UUID()
    let exerciseId: UUID
    let exerciseName: String
    var sets: [WorkoutSet]
    var notes: String
    let date: Date
    var targetReps: String = "" // e.g., "3x5", "4x8-10"
    var targetWeight: Double?
    var lastUsedWeight: Double?
}

struct WorkoutSession: Identifiable, Codable {
    let id = UUID()
    let date: Date
    var exercises: [ExerciseLog]
    var duration: TimeInterval
    var generalNotes: String
    var isCompleted: Bool
    var workoutName: String = ""
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

// MARK: - New Models for Daily Workout Generation
struct GeneratedWorkout: Identifiable, Codable {
    let id: UUID
    let day: Int
    var name: String
    let primaryPattern: MovementPattern
    var primary: Exercise
    var secondary: Exercise
    var supersetA: Exercise
    var supersetB: Exercise
    var conditioning: Exercise
    
    var workoutFormat: String {
        return """
        A) \(primary.name) (Primary \(primaryPattern.rawValue))
        B) \(secondary.name) (Secondary)
        C1) \(supersetA.name) (Superset)
        C2) \(supersetB.name) (Superset)
        D) \(conditioning.name) (Conditioning)
        """
    }
}

// MARK: - Exercise History & Analytics
struct ExerciseAnalytics: Identifiable, Codable {
    let id = UUID()
    let exerciseId: UUID
    var totalSessions: Int
    var totalVolume: Double // weight x reps x sets
    var personalBests: [String: WorkoutSet] // "1RM", "3RM", "5RM", etc.
    var lastUsed: Date?
    var averageRPE: Double?
    var progressTrend: ProgressTrend
}

enum ProgressTrend: String, Codable {
    case improving = "Improving"
    case plateaued = "Plateaued"
    case declining = "Declining"
    case insufficient = "Insufficient Data"
}

// MARK: - Swap Options
struct SwapOption {
    let exercise: Exercise
    let reason: String // "Similar equipment", "Same pattern", "Recently used"
    let lastUsed: Date?
}

// MARK: - Workout Suggestions
struct WorkoutSuggestion {
    let suggestedWeight: Double?
    let suggestedReps: String
    let suggestedRPE: Int?
    let basedOn: String // "Last session", "Progressive overload", "Deload"
}
