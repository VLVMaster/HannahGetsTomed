//
//  ContentView.swift
//  HannahGetsTomed
//

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
            
            GeneratedWorkoutsView()
                .tabItem {
                    Image(systemName: "list.clipboard.fill")
                    Text("Workouts")
                }
                .tag(1)
            
            CalendarView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }
                .tag(2)
            
            WorkoutBuilderView()
                .tabItem {
                    Image(systemName: "plus.square")
                    Text("Builder")
                }
                .tag(3)
            
            WorkoutPlansView()
                .tabItem {
                    Image(systemName: "folder.fill")
                    Text("Plans")
                }
                .tag(4)
        }
        .environmentObject(dataManager)
        .environmentObject(exerciseDB)
        .accentColor(.purple)
    }
}
