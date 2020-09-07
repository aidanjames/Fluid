//
//  TimerCardView.swift
//  Fluid
//
//  Created by Aidan Pendlebury on 26/04/2020.
//  Copyright © 2020 Aidan Pendlebury. All rights reserved.
//

import SwiftUI

struct TimerCardView: View {
    
    @ObservedObject var tasks: TasksViewModel
    @Binding var taskName: String
    
    var body: some View {
        VStack {
            VStack {
                ZStack {
                    if tasks.currentSelectedTask == nil {
                        VStack {
                            HStack {
                                TextField("Add new task", text: $taskName).font(.title).multilineTextAlignment(.center)
                                if !taskName.isEmpty {
                                    Button(action: {
                                        taskName = ""
                                        UIApplication.shared.endEditing()
                                    }) {
                                        CloseButtonView()
                                    }
                                }
                            }
                            Rectangle().fill(Color.gray).frame(height: 1).padding(.horizontal, 50)
                            
                            if !taskName.isEmpty && tasks.currentSelectedTask == nil {
                                Button(action: { buttonPressed() }) {
                                    ButtonView(buttonText: "Start timer", backgroundColour: Color(Colours.midnightBlue), maxWitdh: 120)
                                }
                                .animation(.default)
                                .transition(.move(edge: .trailing))
                                .padding()
                            }
                        }
                        
                    } else {
                        Text(tasks.currentSelectedTask?.name ?? "Error")
                            .font(.title)
                            .bold()
                            .padding(.top)
                            .foregroundColor(Color(Colours.midnightBlue))
                    }
                }
                
                if tasks.isLogging {
                    
                    ZStack {
                        TimeDisplay(logRecordStartTime: tasks.currentSelectedTask?.loggingHistory.last?.startTime ?? Date())
                        LottieView(filename: "clockCoral").frame(width: 80, height: 80).offset(x: 80, y: -8)
                    }
                    
                    HStack {
                        if !tasks.showingPomodoroTimer {
                            Button(action: { withAnimation { tasks.showingPomodoroTimer.toggle() } }) {
                                ButtonView(buttonText: "Add pomodoro", backgroundColour: Color(Colours.midnightBlue), maxWitdh: 120)
                            }
                            .padding(.leading, 45)
                            Spacer()
                        }
                        Button(action: { buttonPressed() }) {
                            ButtonView(buttonText: "End timer", backgroundColour: Color(Colours.hotCoral), maxWitdh: 120)
                        }
                        .padding(.trailing, tasks.showingPomodoroTimer ? 0 : 45)
                        
                    }
                    .padding(.bottom, tasks.showingPomodoroTimer ? 0 : 20)
                    
                    if tasks.showingPomodoroTimer {
                        
                        HStack {
                            Spacer()
                            PomodoroView(showingPomodoroView: $tasks.showingPomodoroTimer).padding().layoutPriority(1)
                            Spacer()
                        }.padding(.bottom)
                        
                    }
                    
                }
                
            }
        }
        .frame(minHeight: tasks.showingPomodoroTimer ? 400 : 200)
        .edgesIgnoringSafeArea(.all)
        .layoutPriority(1)
        .background(Color(Colours.cardViewColour).opacity(1)).cornerRadius(16)
        .padding(.horizontal, 16)
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
            if tasks.isLogging {
                if let currentTask = tasks.currentSelectedTask {
                    // If there's an active pomodoro session, we'll send a notification when the session finishes so no need to send another reminder.
                    if !tasks.showingPomodoroTimer {
                        NotificationManager.shared.scheduleTimerStillRunningNotification(for: currentTask.name)
                    }
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            NotificationManager.shared.cancelAllNotificaitons()
//            if let currentTask = tasks.currentSelectedTask {
//                guard let currentLoggingRecord = currentTask.loggingHistory.last else { return }
//                guard currentLoggingRecord.endTime == nil else { return }
//            }
            UIApplication.shared.isIdleTimerDisabled = tasks.isLogging && tasks.preventScreenLock
        }
    }
    
    func buttonPressed() {
        UIApplication.shared.endEditing()
        if tasks.isLogging {
            withAnimation {
                tasks.stopLoggingForCurrentTask()
                tasks.showingPomodoroTimer = false
            }
        } else {
            if tasks.currentSelectedTask == nil {
                withAnimation { tasks.startLoggingForNewTask(named: taskName) }
                taskName = ""
            } else {
                withAnimation { tasks.startLoggingForCurrentTask() }
            }
        }
    }
    
    
}

struct TimerCardView_Previews: PreviewProvider {
    static var previews: some View {
        TimerCardView(tasks: TasksViewModel(), taskName: .constant(""))
            .previewLayout(.sizeThatFits)
    }
}
