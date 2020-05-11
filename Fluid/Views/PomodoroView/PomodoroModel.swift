//
//  PomodoroModel.swift
//  Fluid
//
//  Created by Aidan Pendlebury on 07/05/2020.
//  Copyright © 2020 Aidan Pendlebury. All rights reserved.
//

import Foundation

enum PomodoroSettings {
    static var numberOfRounds: Int = 3 // Going to depricate this so we just keep rolling until the user cancels the timer
    static var sessionLength: Int = 7 // 25 mins = 1500
    static var shortBreakLength: Int =  3 // 5 mins = 300
    static var longBreakLength: Int = 5 // 20 mins = 1200
    static var numberOfSessionsBeforeLongBreak: Int = 4
    static var autoRollover = true
}


class PomodoroSession: ObservableObject {
    @Published var pomodoros: [Pomodoro] = []
    @Published var currentPomodoro: Int = 0
    @Published var isCounting = true
    
    init() {
        // TODO: Load from file manager, if appropriate
        for round in 1...PomodoroSettings.numberOfRounds {
            for session in 1...PomodoroSettings.numberOfSessionsBeforeLongBreak {
                pomodoros.append(Pomodoro(counter: 0, maxCounter: PomodoroSettings.sessionLength, pomodoroType: .focusSession, startTime: nil))
                if session != PomodoroSettings.numberOfSessionsBeforeLongBreak {
                    pomodoros.append(Pomodoro(counter: 0, maxCounter: PomodoroSettings.shortBreakLength, pomodoroType: .shortBreak, startTime: nil))
                }
            }
            if round != PomodoroSettings.numberOfRounds {
                pomodoros.append(Pomodoro(counter: 0, maxCounter: PomodoroSettings.longBreakLength, pomodoroType: .longBreak, startTime: nil))
            }
        }
    }
}


struct Pomodoro {
    var counter: Int
    let maxCounter: Int
    let pomodoroType: PomodoroType
    let startTime: Date?
}

enum PomodoroType {
    case focusSession, shortBreak, longBreak
}



