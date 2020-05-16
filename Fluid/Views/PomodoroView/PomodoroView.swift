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
    @State private var showingSettingsScreen = false
    
    var currentPomodoroType: PomodoroType { pomodoroSession.pomodoros[pomodoroSession.currentPomodoro].pomodoroType }
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            HStack {
                RingView(pomodoroSession: self.pomodoroSession)
                    .onReceive(timer) { _ in
                        guard self.pomodoroSession.isCounting else { return }
                        self.pomodoroSession.incrementCounter()
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text("\(currentPomodoroType == .focusSession ? "Focus session" : currentPomodoroType == .shortBreak ? "Short Break" : "Long break")")
                        .foregroundColor(pomodoroSession.colourForCurrentPomodoroType())
                    ProgressDotView(pomodoroSession: self.pomodoroSession)
                    Spacer()
                    Button(action: { self.pomodoroSession.skipToNextPomodoro() }) {
                        HStack {
                            Text("Skip")
                            SFSymbols.advance
                        }
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(.vertical, 7)
                        .padding(.horizontal, 15)
                        .background(Color(Colours.midnightBlue))
                        .cornerRadius(10)
                    }
                    .padding(.top, 10)
                }
                .padding(.leading)
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 30)
            
            VStack {
                HStack {
                    Button(action: {
                        self.showingSettingsScreen.toggle()
                    }) {
                        Images.cog
                        .padding(.leading, 10)
                        .padding(.top, 10)
                        }
                    .buttonStyle(PlainButtonStyle())
                    .sheet(isPresented: $showingSettingsScreen) {
                        PomodoroSettingsView(pomodoroSession: self.pomodoroSession)
                    }
                    Spacer()
                    Button(action: {
                        self.pomodoroSession.isCounting = false
                        self.pomodoroSession.pomodoros[self.pomodoroSession.currentPomodoro].counter = 0
                        withAnimation { self.showingPomodoroView = false }
                    }) {
                        SFSymbols.closeCircle.foregroundColor(.black)
                            .font(.headline)
                        .padding(.trailing, 10)
                        .padding(.top, 10)
                    }
                }

                Spacer()

            }

        }
        .frame(maxWidth: 300, maxHeight: 150)
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

    
    
}

struct PomodoroView_Previews: PreviewProvider {
    static var previews: some View {
        PomodoroView(showingPomodoroView: .constant(true))
    }
}
