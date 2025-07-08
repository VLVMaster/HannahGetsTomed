//
//  WorkoutTimer.swift
//  HannahGetsTomed
//
//  Created by Hannah Mercer on 07/07/2025.
//


// WorkoutTimer.swift
import Foundation
import SwiftUI

class WorkoutTimer: ObservableObject {
    @Published var isRunning = false
    @Published var startTime: Date?
    @Published var duration: TimeInterval = 0
    
    private var timer: Timer?
    
    func start() {
        guard !isRunning else { return }
        
        startTime = Date()
        isRunning = true
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if let startTime = self.startTime {
                self.duration = Date().timeIntervalSince(startTime)
            }
        }
    }
    
    func stop() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }
    
    func reset() {
        stop()
        duration = 0
        startTime = nil
    }
    
    var formattedDuration: String {
        let hours = Int(duration) / 3600
        let minutes = Int(duration) % 3600 / 60
        let seconds = Int(duration) % 60
        
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%d:%02d", minutes, seconds)
        }
    }
}