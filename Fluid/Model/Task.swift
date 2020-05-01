//
//  Task.swift
//  Fluid
//
//  Created by Aidan Pendlebury on 28/04/2020.
//  Copyright © 2020 Aidan Pendlebury. All rights reserved.
//

import Foundation

struct Task: Identifiable, Codable {
    var id = UUID()
    var name: String
    var loggingHistory: [LoggingRecord]
    var totalTimeInSeconds: Int { return loggingHistory.reduce(0) { $0 + $1.calculatedSeconds} }
    
    init(name: String, loggingHistory: [LoggingRecord]) {
        self.name = name
        self.loggingHistory = loggingHistory
    }
}

class LoggingRecord: Codable {
    var taskID: UUID
    var startTime: Date
    var endTime: Date?
    
    var calculatedSeconds: Int {
        guard let endTime = self.endTime else { return 0 }
        let time = endTime.timeIntervalSince(startTime)
        return Int(time)
    }
    
    init(taskID: UUID, startTime: Date, endTime: Date?) {
        self.taskID = taskID
        self.startTime = startTime
        self.endTime = endTime
    }
}

class Tasks: ObservableObject {
    @Published var allTasks: [Task] = []
    
    init() {
        if let savedTasks: [Task] = FileManager.default.fetchData(from: FMKeys.allTasks) {
            self.allTasks = savedTasks
        }
    }
    
    init(tasks: [Task]) {
        self.allTasks = tasks
    }
}
