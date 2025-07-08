//
//  WorkoutPlansView.swift
//  HannahGetsTomed
//
//  Created by Hannah Mercer on 07/07/2025.
//


// WorkoutPlansView.swift
import SwiftUI

struct WorkoutPlansView: View {
    @EnvironmentObject var dataManager: WorkoutDataManager
    @State private var showingNewPlan = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Workout Plans")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Create and manage your training blocks")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Button("Create New Plan") {
                    showingNewPlan = true
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Plans")
        }
        .sheet(isPresented: $showingNewPlan) {
            NewWorkoutPlanView()
        }
    }
}

struct NewWorkoutPlanView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var planName = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("Plan Details") {
                    TextField("Plan Name", text: $planName)
                }
            }
            .navigationTitle("New Plan")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Create") {
                        dismiss()
                    }
                    .disabled(planName.isEmpty)
                }
            }
        }
    }
}