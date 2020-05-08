//
//  PomodoroView.swift
//  Fluid
//
//  Created by Aidan Pendlebury on 07/05/2020.
//  Copyright © 2020 Aidan Pendlebury. All rights reserved.
//

import SwiftUI

struct PomodoroView: View {
    
    @ObservedObject var pomodoroSession = PomodoroSession()
    @Binding var showingPomodoroView: Bool
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            RingView(pomodoroSession: self.pomodoroSession)
                .onReceive(timer) { _ in
                    self.timerFired()
            }
            Button(action: {
                self.pomodoroSession.isCounting = false
                self.pomodoroSession.pomodoros[self.pomodoroSession.currentPomodoro].counter = 0
                self.showingPomodoroView = false
            }) {
                SFSymbols.closeCircle.foregroundColor(.black)
            }
        .offset(x: 50, y: -50)
        }
        // TODO: Save pomodoro session to filemanager if app goes into background
        // TODO: Set an alert for when the next session is up
        // TODO: Update the counter when the app returns to the foreground
    }
    
    func timerFired() {
        guard pomodoroSession.isCounting else { return }
        if pomodoroSession.pomodoros[pomodoroSession.currentPomodoro].counter < pomodoroSession.pomodoros[pomodoroSession.currentPomodoro].maxCounter {
            withAnimation { pomodoroSession.pomodoros[pomodoroSession.currentPomodoro].counter += 1 }
        } else if pomodoroSession.currentPomodoro < pomodoroSession.pomodoros.count - 1 && PomodoroSettings.autoRollover {
            pomodoroSession.currentPomodoro += 1
        }
    }
    
    
}

struct PomodoroView_Previews: PreviewProvider {
    static var previews: some View {
        PomodoroView(showingPomodoroView: .constant(true))
    }
}
