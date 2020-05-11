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
    
    var currentPomodoroType: PomodoroType { pomodoroSession.pomodoros[pomodoroSession.currentPomodoro].pomodoroType }
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            HStack {
                RingView(pomodoroSession: self.pomodoroSession)
                    .onReceive(timer) { _ in
                        self.timerFired()
                }
                Spacer()
                Text("\(currentPomodoroType == .focusSession ? "In session" : currentPomodoroType == .shortBreak ? "Short Break" : "Long break")")
                    .foregroundColor(Color("\(currentPomodoroType == .focusSession ? Colours.hotCoral : Colours.midnightBlue)"))
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 30)

            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        self.pomodoroSession.isCounting = false
                        self.pomodoroSession.pomodoros[self.pomodoroSession.currentPomodoro].counter = 0
                        withAnimation { self.showingPomodoroView = false }
                    }) {
                        SFSymbols.closeCircle.foregroundColor(.black)
                    }
                }
                .padding(.trailing, 15)
                .padding(.top, 15)
                Spacer()
            }
            
        }
        .frame(maxWidth: 250, maxHeight: 140)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.gray.opacity(0.5), radius: 10, x: 0, y: 5)
        
        
        
        
    }
    
    // TODO: Save pomodoro session to filemanager if app goes into background
    // TODO: Set an alert for when the next session is up
    // TODO: Update the counter when the app returns to the foreground
    
    func timerFired() {
        guard pomodoroSession.isCounting else { return }
        
        // If the current session has not finished, increment the counter, else, roll over to the next pomodoro (but only if we have one left in the array).
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
