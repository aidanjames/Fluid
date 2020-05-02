//
//  TaskViewModel.swift
//  Fluid
//
//  Created by Aidan Pendlebury on 02/05/2020.
//  Copyright © 2020 Aidan Pendlebury. All rights reserved.
//

import Foundation
import SwiftUI

class TasksViewModel: ObservableObject {
    @Published var allTasks: [Task] = []
    @Published var currentSelectedTask: Task?
    
    
    init() {
        print("TaskViewModel init being called")
        if let savedTasks: [Task] = FileManager.default.fetchData(from: FMKeys.allTasks) {
            self.allTasks = savedTasks
        }
        if let savedCurrentTask: Task = FileManager.default.fetchData(from: FMKeys.currentTask) {
            if let index = allTasks.firstIndex(where: { $0.id == savedCurrentTask.id }) {
                self.currentSelectedTask = allTasks[index]
                if currentSelectedTask?.loggingHistory.last?.endTime == nil {
                    MyTimer.shared.startTimer()
                    MyTimer.shared.counter = Int(Date().timeIntervalSince(currentSelectedTask?.loggingHistory.last!.startTime ?? Date()))
                }
            }
        }
    }
    
    
    // Helper initialiser for mock data
    init(tasks: [Task]) {
        self.allTasks = tasks
    }
    
    
    func startLoggingForNewTask(named taskName: String) {
        let newTask = Task(name: taskName, loggingHistory: [])
        currentSelectedTask = newTask
        allTasks.insert(newTask, at: 0)
        startLoggingForCurrentTask()
    }
    
    
    func startLoggingForCurrentTask() {
        guard currentSelectedTask != nil else { fatalError() }
        MyTimer.shared.maxCounter = 1500
        MyTimer.shared.startTimer()
        currentSelectedTask!.loggingHistory.append(LoggingRecord(taskID: currentSelectedTask!.id))
        persistTaskViewModelState()
    }

    
    func stopLoggingForCurrentTask() {
        MyTimer.shared.stopTimer()
        guard currentSelectedTask != nil else { fatalError() }
        guard let loggingRecord = currentSelectedTask!.loggingHistory.last else { fatalError("There's no logging record to update.") }
        loggingRecord.endTime = Date()
        currentSelectedTask = nil
        persistTaskViewModelState()
    }
    
    
    func delete(task: Task) {
        if let index = allTasks.firstIndex(where: { $0.id == task.id }) {
            allTasks.remove(at: index)
            persistTaskViewModelState()
        }
    }
    
    
    func discardInFlightLoggingRecord() {
        guard currentSelectedTask?.loggingHistory.last?.endTime == nil else { fatalError("The last logging record is not in-flight.") }
        currentSelectedTask?.loggingHistory.removeLast()
        MyTimer.shared.stopTimer()
        currentSelectedTask = nil
    }
    
    
    private func persistTaskViewModelState() {
        FileManager.default.writeData(allTasks, to: FMKeys.allTasks)
        FileManager.default.writeData(currentSelectedTask, to: FMKeys.currentTask)
    }
    
    
}
