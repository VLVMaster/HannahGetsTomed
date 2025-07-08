//
//  WorkoutLogView.swift
//  HannahGetsTomed
//
//  Created by Hannah Mercer on 07/07/2025.
//


// WorkoutLogView.swift
import SwiftUI

struct WorkoutLogView: View {
    @EnvironmentObject var dataManager: WorkoutDataManager
    @Environment(\.dismiss) private var dismiss
    @State private var exerciseLogs: [ExerciseLog] = []
    @State private var generalNotes = ""
    
    var body: some View {
        NavigationView {
            VStack {
                // Timer header
                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(.purple)
                    
                    Text(dataManager.currentTimer.formattedDuration)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Button(action: {
                        if dataManager.currentTimer.isRunning {
                            dataManager.currentTimer.stop()
                        } else {
                            dataManager.currentTimer.start()
                        }
                    }) {
                        Image(systemName: dataManager.currentTimer.isRunning ? "pause.circle.fill" : "play.circle.fill")
                            .font(.title2)
                            .foregroundColor(.purple)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                
                ScrollView {
                    VStack(spacing: 20) {
                        Text("Add exercises to start logging your workout")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        Button("Add Exercise") {
                            // TODO: Show exercise selection
                        }
                        .buttonStyle(.borderedProminent)
                        
                        if !generalNotes.isEmpty {
                            TextField("Workout notes...", text: $generalNotes, axis: .vertical)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                    .padding()
                }
                
                Spacer()
            }
            .navigationTitle("Log Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dataManager.currentTimer.reset()
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveWorkout()
                    }
                    .disabled(exerciseLogs.isEmpty)
                }
            }
        }
        .onAppear {
            if !dataManager.currentTimer.isRunning {
                dataManager.currentTimer.start()
            }
        }
    }
    
    private func saveWorkout() {
        let session = WorkoutSession(
            date: Date(),
            exercises: exerciseLogs,
            duration: dataManager.currentTimer.duration,
            generalNotes: generalNotes,
            isCompleted: true
        )
        
        dataManager.addWorkoutSession(session)
        dataManager.currentTimer.reset()
        dismiss()
    }
}
