//
//  PomodoroModel.swift
//  Fluid
//
//  Created by Aidan Pendlebury on 07/05/2020.
//  Copyright © 2020 Aidan Pendlebury. All rights reserved.
//

import Foundation

enum PomodoroSettings {
    static var sessionLength: Int = 1500 // 25 mins = 1500
    static var shortBreakLength: Int =  300 // 5 mins = 300
    static var longBreakLength: Int = 1200 // 20 mins = 1200
    static var numberOfSessionsBeforeLongBreak: Int = 4
    static var autoRollover = true
}


class PomodoroSession: ObservableObject {
    @Published var pomodoros: [Pomodoro] = []
    @Published var currentPomodoro: Int = 0
    @Published var isCounting = true
    
    init() {
        print("Pomodoro initialiser being called")

        loadInFlightPomodoroState()
        
        guard pomodoros.isEmpty else { return }

        for session in 1...PomodoroSettings.numberOfSessionsBeforeLongBreak {
            pomodoros.append(Pomodoro(counter: 0, maxCounter: PomodoroSettings.sessionLength, pomodoroType: .focusSession, startTime: nil, endTime: nil))
            if session != PomodoroSettings.numberOfSessionsBeforeLongBreak {
                pomodoros.append(Pomodoro(counter: 0, maxCounter: PomodoroSettings.shortBreakLength, pomodoroType: .shortBreak, startTime: nil, endTime: nil))
            }
        }
        pomodoros.append(Pomodoro(counter: 0, maxCounter: PomodoroSettings.longBreakLength, pomodoroType: .longBreak, startTime: nil, endTime: nil))
        pomodoros[currentPomodoro].startTime = Date()
        pomodoros[currentPomodoro].endTime = Calendar.current.date(byAdding: .second, value: PomodoroSettings.sessionLength, to: Date())
        persistInFlightPomodoroState()
    }
    
    
    func incrementCounter() {
        guard isCounting else { return }

        if pomodoros[currentPomodoro].counter < pomodoros[currentPomodoro].maxCounter {
            pomodoros[currentPomodoro].counter += 1
        } else if currentPomodoro < (pomodoros.count - 1) && PomodoroSettings.autoRollover {
            currentPomodoro += 1
            pomodoros[currentPomodoro].counter = 0
            pomodoros[currentPomodoro].startTime = Date()
            pomodoros[currentPomodoro].endTime = Calendar.current.date(byAdding: .second, value: pomodoros[currentPomodoro].pomodoroType == .focusSession ? PomodoroSettings.sessionLength : pomodoros[currentPomodoro].pomodoroType == .shortBreak ? PomodoroSettings.shortBreakLength : PomodoroSettings.longBreakLength, to: Date())
            persistInFlightPomodoroState()
        } else {
            currentPomodoro = 0
            pomodoros[currentPomodoro].counter = 0
            pomodoros[currentPomodoro].startTime = Date()
            pomodoros[currentPomodoro].endTime = Calendar.current.date(byAdding: .second, value: pomodoros[currentPomodoro].pomodoroType == .focusSession ? PomodoroSettings.sessionLength : pomodoros[currentPomodoro].pomodoroType == .shortBreak ? PomodoroSettings.shortBreakLength : PomodoroSettings.longBreakLength, to: Date())
            persistInFlightPomodoroState()
        }
    }
    
    
    func persistInFlightPomodoroState() {
        FileManager.default.writeData(pomodoros, to: FMKeys.pomodoros)
        FileManager.default.writeData(currentPomodoro, to: FMKeys.currentPomodoro)
        FileManager.default.writeData(isCounting, to: FMKeys.pomodoroIsCounting)
    }
    
    
    func loadInFlightPomodoroState() {
        if let inFlightPomodoros: [Pomodoro] = FileManager.default.fetchData(from: FMKeys.pomodoros) {
            self.pomodoros = inFlightPomodoros
            if let currentPomodoro: Int = FileManager.default.fetchData(from: FMKeys.currentPomodoro) {
                self.currentPomodoro = currentPomodoro
                if let isCounting: Bool = FileManager.default.fetchData(from: FMKeys.pomodoroIsCounting) {
                    self.isCounting = isCounting
                    
                    // Adjust the counter based on the start date
                    if let endTime = pomodoros[currentPomodoro].endTime {
                        if Date() < endTime {
                            if let startTime = pomodoros[currentPomodoro].startTime {
                                pomodoros[currentPomodoro].counter = Int(Date().timeIntervalSince(startTime))
                            }
                        } else {
                            pomodoros[currentPomodoro].counter = pomodoros[currentPomodoro].maxCounter
                            self.isCounting = false
                        }
                    }
                }
            }
        }
    }
    
    
    func deleteInFlightPromodoroState() {
        FileManager.default.deleteData(from: FMKeys.pomodoros)
        FileManager.default.deleteData(from: FMKeys.currentPomodoro)
        FileManager.default.deleteData(from: FMKeys.pomodoroIsCounting)
    }
    
    deinit {
        deleteInFlightPromodoroState()
    }
    
    
    
}


struct Pomodoro: Codable {
    var counter: Int
    let maxCounter: Int
    let pomodoroType: PomodoroType
    var startTime: Date?
    var endTime: Date?
}

enum PomodoroType: String, Codable {
    case focusSession, shortBreak, longBreak
}



