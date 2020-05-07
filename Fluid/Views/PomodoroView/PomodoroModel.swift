//
//  PomodoroModel.swift
//  Fluid
//
//  Created by Aidan Pendlebury on 07/05/2020.
//  Copyright © 2020 Aidan Pendlebury. All rights reserved.
//

import Foundation

enum PomodoroSettings {
    static var numberOfRounds: Int = 1
    static var sessionLength: Int = 1500
    static var shortBreakLength: Int =  300
    static var longBreakLength: Int = 1200
    static var numberOfSessionsBeforeLongBreak: Int = 1
    static var autoRollover = false
}


struct PomodoroSession {
    var pomodoros: [Pomodoro] = []
    var currentPomodoro: Int = 0
    
    init() {
        for round in 1...PomodoroSettings.numberOfRounds {
            for session in 1...PomodoroSettings.numberOfSessionsBeforeLongBreak {
                pomodoros.append(Pomodoro(counter: 0, maxCounter: PomodoroSettings.sessionLength, pomodoroType: .focusSession))
                if session != PomodoroSettings.numberOfSessionsBeforeLongBreak {
                    pomodoros.append(Pomodoro(counter: 0, maxCounter: PomodoroSettings.shortBreakLength, pomodoroType: .shortBreak))
                }
            }
            if round != PomodoroSettings.numberOfRounds {
                pomodoros.append(Pomodoro(counter: 0, maxCounter: PomodoroSettings.longBreakLength, pomodoroType: .longBreak))
            }
        }
        print(pomodoros)
    }
}


struct Pomodoro {
    let counter: Int
    let maxCounter: Int
    let pomodoroType: PomodoroType
}

enum PomodoroType {
    case focusSession, shortBreak, longBreak
}



