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
}


enum LottieAnimations {
    static let tickingClock = "clock-simple-animated"
}


enum Images {
    static let flowIcon = Image("flow")
    static let tomatoIcon = Image("tomato")
}


enum FMKeys {
    static let allTasks = "allTasks"
    static let currentTask = "currentTask"
}


// Will eventually replace this with GeometryReader.
let screen = UIScreen.main.bounds
