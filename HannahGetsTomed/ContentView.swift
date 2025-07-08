//
//  ContentView.swift
//  HannahGetsTomed
//
//  Created by Hannah Mercer on 07/07/2025.
//


// ContentView.swift
import SwiftUI

struct ContentView: View {
    @StateObject private var dataManager = WorkoutDataManager()
    @StateObject private var exerciseDB = ExerciseDatabase()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            CalendarView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }
                .tag(1)
            
            WorkoutPlansView()
                .tabItem {
                    Image(systemName: "list.clipboard")
                    Text("Plans")
                }
                .tag(2)
            
            WorkoutBuilderView()
                .tabItem {
                    Image(systemName: "plus.square")
                    Text("Builder")
                }
                .tag(3)
        }
        .environmentObject(dataManager)
        .environmentObject(exerciseDB)
        .accentColor(.purple)
    }
}
