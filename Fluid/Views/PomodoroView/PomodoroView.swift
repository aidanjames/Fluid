//
//  PomodoroView.swift
//  Fluid
//
//  Created by Aidan Pendlebury on 07/05/2020.
//  Copyright © 2020 Aidan Pendlebury. All rights reserved.
//

import SwiftUI

struct PomodoroView: View {
    
    @StateObject var pomodoroSession = PomodoroSession()
    @Binding var showingPomodoroView: Bool
    @State private var showingSettingsScreen = false
    
    var currentPomodoroType: PomodoroType { pomodoroSession.pomodoros[pomodoroSession.currentPomodoro].pomodoroType }
    
    @Environment(\.colorScheme) var colorScheme
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            HStack {
                RingView(pomodoroSession: pomodoroSession)
                    .onReceive(timer) { _ in
                        guard pomodoroSession.isCounting else { return }
                        pomodoroSession.incrementCounter()
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text("\(currentPomodoroType == .focusSession ? "Focus session" : currentPomodoroType == .shortBreak ? "Short Break" : "Long break")")
                        .foregroundColor(pomodoroSession.colourForCurrentPomodoroType())
                    ProgressDotView(pomodoroSession: pomodoroSession)
                    Spacer()
                    Button(action: { pomodoroSession.skipToNextPomodoro() }) {
                        HStack {
                            Text("Skip")
                            SFSymbols.advance
                        }
                        .font(.caption)
                        .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
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
                        showingSettingsScreen.toggle()
                    }) {
                        Images.cog
                            .padding(.leading, 10)
                            .padding(.top, 10)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .sheet(isPresented: $showingSettingsScreen) {
                        PomodoroSettingsView(pomodoroSession: pomodoroSession)
                    }
                    Spacer()
                    Button(action: {
                        pomodoroSession.isCounting = false
                        pomodoroSession.pomodoros[pomodoroSession.currentPomodoro].counter = 0
                        withAnimation { showingPomodoroView = false }
                    }) {
                        SFSymbols.closeCircle.foregroundColor(Color(Colours.midnightBlue))
                            .scaleEffect(0.75)
                            .font(.title)
                            .padding(.trailing, 10)
                            .padding(.top, 10)
                    }
                }
                
                Spacer()
                
            }
            
        }
        .frame(maxWidth: 300, maxHeight: 150)
        
        .background(Color(Colours.cardViewColour))
         
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(Colours.midnightBlue).opacity(colorScheme == .dark ? 0.2 : 0.1)))
        .shadow(color: Color(Colours.shadow).opacity(0.5), radius: 10, x: 0, y: 5)
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
            pomodoroSession.persistInFlightPomodoroState()
            guard pomodoroSession.isCounting else { return }
            let secondsRemaining = pomodoroSession.pomodoros[pomodoroSession.currentPomodoro].maxCounter - pomodoroSession.pomodoros[pomodoroSession.currentPomodoro].counter
            switch pomodoroSession.pomodoros[pomodoroSession.currentPomodoro].pomodoroType {
            case .focusSession:
                NotificationManager.shared.scheduleSessionFinishedNotification(timeInterval: Double(secondsRemaining))
            case .shortBreak, .longBreak:
                NotificationManager.shared.scheduleBreakFinishedNotification(timeInterval: Double(secondsRemaining))
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            pomodoroSession.loadInFlightPomodoroState()
        }
        
        
    }
    
    
    
}

struct PomodoroView_Previews: PreviewProvider {
    static var previews: some View {
            ZStack {
                Color(Colours.cardViewColour).edgesIgnoringSafeArea(.all)
                PomodoroView(showingPomodoroView: .constant(true))
                
            }
//            .colorScheme(.dark)
        }
}
