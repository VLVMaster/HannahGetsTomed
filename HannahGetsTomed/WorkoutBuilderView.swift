//
//  WorkoutBuilderView.swift
//  HannahGetsTomed
//
//  Created by Hannah Mercer on 07/07/2025.
//


// WorkoutBuilderView.swift
import SwiftUI

struct WorkoutBuilderView: View {
    @EnvironmentObject var exerciseDB: ExerciseDatabase
    @State private var selectedPattern: MovementPattern = .squat
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Workout Builder")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Design your perfect workout")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Picker("Movement Pattern", selection: $selectedPattern) {
                    ForEach(MovementPattern.allCases.filter { $0 != .cardio && $0 != .fullBody }, id: \.self) { pattern in
                        Text(pattern.rawValue).tag(pattern)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Spacer()
            }
            .padding()
            .navigationTitle("Builder")
        }
    }
}
