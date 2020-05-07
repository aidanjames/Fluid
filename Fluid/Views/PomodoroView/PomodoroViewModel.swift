//
//  PomodoroViewModel.swift
//  Fluid
//
//  Created by Aidan Pendlebury on 07/05/2020.
//  Copyright © 2020 Aidan Pendlebury. All rights reserved.
//

import Foundation

class PomodoroViewModel: ObservableObject {
    
    @Published var counter = MyTimer() // This just ticks away
    @Published var pomodoroSession = PomodoroSession()
    
    /*
     Configuration items:
     - Auto rollover - i.e. do not require user interaction (default = false)
     - Session length (default = 25 min)
     - Short Break length (default = 5 min)
     - Long break length (default = 20 min)
     - Number of sessions between long breaks (default = 4)
     */
    
    init() {
        
    }
    
    
    
    func startPomodoroTimer() {
        
    }
    
    func stopPomodoroTimer() {
        
    }
    
    
}
