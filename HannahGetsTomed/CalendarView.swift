//
//  CalendarView.swift
//  HannahGetsTomed
//
//  Created by Hannah Mercer on 07/07/2025.
//


// CalendarView.swift
import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var dataManager: WorkoutDataManager
    @State private var selectedDate = Date()
    @State private var currentMonth = Date()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Calendar")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Track your workout history")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Calendar")
        }
    }
}