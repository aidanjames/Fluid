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
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
            self.pomodoroSession.persistInFlightPomodoroState()
            
            guard self.pomodoroSession.isCounting else { return }
            
            let secondsRemaining = self.pomodoroSession.pomodoros[self.pomodoroSession.currentPomodoro].maxCounter - self.pomodoroSession.pomodoros[self.pomodoroSession.currentPomodoro].counter
            
            switch self.pomodoroSession.pomodoros[self.pomodoroSession.currentPomodoro].pomodoroType {
            case .focusSession:
                NotificationManager.shared.scheduleSessionFinishedNotification(timeInterval: Double(secondsRemaining))
            case .shortBreak, .longBreak:
                NotificationManager.shared.scheduleBreakFinishedNotification(timeInterval: Double(secondsRemaining))
            }
            
            
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            self.pomodoroSession.loadInFlightPomodoroState()
        }

        
    }

    
    func timerFired() {
        guard pomodoroSession.isCounting else { return }
        pomodoroSession.incrementCounter()
    }
    
    
}

struct PomodoroView_Previews: PreviewProvider {
    static var previews: some View {
        PomodoroView(showingPomodoroView: .constant(true))
    }
}
