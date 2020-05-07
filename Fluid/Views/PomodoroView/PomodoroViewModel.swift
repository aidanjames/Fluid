//
//  PomodoroViewModel.swift
//  Fluid
//
//  Created by Aidan Pendlebury on 07/05/2020.
//  Copyright © 2020 Aidan Pendlebury. All rights reserved.
//

import Foundation

class PomodoroViewModel: ObservableObject {
    
    @Published var counter = MyTimer.shared
    
    func startPomodoroTimer() {
        guard !counter.isCounting else { return }
        counter.startTimer()
    }
    
    func stopPomodoroTimer() {
        guard counter.isCounting else { return }
        counter.stopTimer()
    }
    
    
}
