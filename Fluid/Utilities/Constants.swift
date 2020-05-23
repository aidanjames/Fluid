//
//  Constants.swift
//  Fluid
//
//  Created by Aidan Pendlebury on 29/04/2020.
//  Copyright © 2020 Aidan Pendlebury. All rights reserved.
//

import SwiftUI

enum SFSymbols {
    static let trashButton = Image(systemName: "trash")
    static let stopButton = Image(systemName: "stop.circle.fill")
    static let playButton = Image(systemName: "play.circle.fill")
    static let moreButton = Image(systemName: "ellipsis.circle")
    static let moreButtonWithoutCircle = Image(systemName: "ellipsis")
    static let closeCircle = Image(systemName: "xmark.circle.fill")
    static let advance = Image(systemName: "arrow.right")
    static let pencil = Image(systemName: "pencil.circle")
    static let chart = Image(systemName: "chart.bar.fill")
    static let list = Image(systemName: "list.dash")
}


enum LottieAnimations {
    static let tickingClock = "clock-simple-animated"
}


enum Images {
    static let cog = Image("cog")
}


enum FMKeys {
    static let allTasks = "allTasks"
    static let currentTask = "currentTask"
    static let showingPomodoroTimer = "showingPomodoroTimer"
    static let pomodoros = "pomodoros"
    static let currentPomodoro = "currentPomodoro"
    static let pomodoroIsCounting = "pomodoroIsCounting"
    static let pomodoroSettings = "pomodoroSettings"
}

enum Colours {
    static let midnightBlue = "Midnight_Blue"
    static let hotCoral = "Hot_Coral"
}


// Will eventually replace this with GeometryReader.
let screen = UIScreen.main.bounds
