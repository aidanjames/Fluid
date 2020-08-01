//
//  PomodoroModel.swift
//  Fluid
//
//  Created by Aidan Pendlebury on 07/05/2020.
//  Copyright © 2020 Aidan Pendlebury. All rights reserved.
//

import AVFoundation
import SwiftUI

enum PomodoroSettings {
    static var sessionLength: Int = 1500 // 25 mins = 1500
    static var shortBreakLength: Int = 300  // 5 mins = 300
    static var longBreakLength: Int = 1200 // 20 mins = 1200
    static var numberOfSessionsBeforeLongBreak: Int = 4
    static var autoRollover = true
}


class PomodoroSession: ObservableObject {
    @Published var pomodoros: [Pomodoro] = []
    @Published var currentPomodoro: Int = 0
    @Published var isCounting = true
    
    
    init() {
        loadInFlightPomodoroState()
        guard pomodoros.isEmpty else { return }
        resetPomodoroSession()
    }
    
    
    func resetPomodoroSession() {
        pomodoros.removeAll()
        currentPomodoro = 0
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
            if pomodoros[currentPomodoro].state == .toDo { pomodoros[currentPomodoro].state = .active }
            pomodoros[currentPomodoro].counter += 1
        } else if currentPomodoro < (pomodoros.count - 1) && PomodoroSettings.autoRollover {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            pomodoros[currentPomodoro].state = .done
            currentPomodoro += 1
            pomodoros[currentPomodoro].state = .active
            pomodoros[currentPomodoro].counter = 0
            pomodoros[currentPomodoro].startTime = Date()
            pomodoros[currentPomodoro].endTime = Calendar.current.date(byAdding: .second, value: pomodoros[currentPomodoro].pomodoroType == .focusSession ? PomodoroSettings.sessionLength : pomodoros[currentPomodoro].pomodoroType == .shortBreak ? PomodoroSettings.shortBreakLength : PomodoroSettings.longBreakLength, to: Date())
            persistInFlightPomodoroState()
        } else {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            currentPomodoro = 0
            // Not sure why I can't use map here.
            for i in 0..<pomodoros.count {
                pomodoros[i].state = .toDo
            }
            pomodoros[currentPomodoro].state = .active
            pomodoros[currentPomodoro].counter = 0
            pomodoros[currentPomodoro].startTime = Date()
            pomodoros[currentPomodoro].endTime = Calendar.current.date(byAdding: .second, value: pomodoros[currentPomodoro].pomodoroType == .focusSession ? PomodoroSettings.sessionLength : pomodoros[currentPomodoro].pomodoroType == .shortBreak ? PomodoroSettings.shortBreakLength : PomodoroSettings.longBreakLength, to: Date())
            persistInFlightPomodoroState()
        }
    }
    
    
    func skipToNextPomodoro() {
        if currentPomodoro < pomodoros.count - 1 {
            pomodoros[currentPomodoro].state = .done
            currentPomodoro += 1
            pomodoros[currentPomodoro].startTime = Date()
            pomodoros[currentPomodoro].endTime = Calendar.current.date(byAdding: .second, value: pomodoros[currentPomodoro].pomodoroType == .focusSession ? PomodoroSettings.sessionLength : pomodoros[currentPomodoro].pomodoroType == .shortBreak ? PomodoroSettings.shortBreakLength : PomodoroSettings.longBreakLength, to: Date())
        } else {
            for i in 0..<pomodoros.count {
                pomodoros[i].state = .toDo
            }
            currentPomodoro = 0
            pomodoros[currentPomodoro].startTime = Date()
            pomodoros[currentPomodoro].endTime = Calendar.current.date(byAdding: .second, value: pomodoros[currentPomodoro].pomodoroType == .focusSession ? PomodoroSettings.sessionLength : pomodoros[currentPomodoro].pomodoroType == .shortBreak ? PomodoroSettings.shortBreakLength : PomodoroSettings.longBreakLength, to: Date())
        }
        pomodoros[currentPomodoro].counter = 0
        isCounting = true
        persistInFlightPomodoroState()
    }
    
    
    func colourForCurrentPomodoroType() -> Color {
        switch pomodoros[currentPomodoro].pomodoroType {
        case .focusSession:
            return Color(Colours.hotCoral)
        case .shortBreak:
            return Color.green
        case .longBreak:
            return Color.blue
        }
    }
    
    
    func persistInFlightPomodoroState() {
        FileManager.default.writeData(pomodoros, to: FMKeys.pomodoros)
        FileManager.default.writeData(currentPomodoro, to: FMKeys.currentPomodoro)
        FileManager.default.writeData(isCounting, to: FMKeys.pomodoroIsCounting)
        
        let pomoSettings = [PomodoroSettings.sessionLength, PomodoroSettings.shortBreakLength, PomodoroSettings.longBreakLength, PomodoroSettings.numberOfSessionsBeforeLongBreak]
        FileManager.default.writeData(pomoSettings, to: FMKeys.pomodoroSettings)
    }
    
    
    func loadInFlightPomodoroState() {
        if let pomoSettings: [Int] = FileManager.default.fetchData(from: FMKeys.pomodoroSettings) {
            PomodoroSettings.sessionLength = pomoSettings[0]
            PomodoroSettings.shortBreakLength = pomoSettings[1]
            PomodoroSettings.longBreakLength = pomoSettings[2]
            PomodoroSettings.numberOfSessionsBeforeLongBreak = pomoSettings[3]
        }
        if let inFlightPomodoros: [Pomodoro] = FileManager.default.fetchData(from: FMKeys.pomodoros) {
            pomodoros = inFlightPomodoros
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


struct Pomodoro: Codable, Identifiable {
    var id = UUID()
    var state: PomodoroState = .toDo
    var counter: Int
    let maxCounter: Int
    let pomodoroType: PomodoroType
    var startTime: Date?
    var endTime: Date?
}

enum PomodoroType: String, Codable {
    case focusSession, shortBreak, longBreak
}

enum PomodoroState: String, Codable {
    case done, active, toDo
}



