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
    
    @State private var taskName = ""
    @State private var showingPomodoroTimer = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                VStack {
                    HStack {
                        VStack(spacing: 0) {
                            if tasks.currentSelectedTask == nil {
                                TextField("New task", text: $taskName)
                                Rectangle().fill(Color.gray).frame(height: 1)
                                
                            } else {
                                Text(tasks.currentSelectedTask?.name ?? "Error")
                                Rectangle().fill(Color.gray).frame(height: 1).opacity(0)
                                
                            }
                        }
                        .padding(.top)
                        Spacer()
                        if !taskName.isEmpty || tasks.currentSelectedTask != nil {
                            Button(action: { self.buttonPressed() }) {
                                (tasks.isLogging ? SFSymbols.stopButton : SFSymbols.playButton)
                                    .font(.largeTitle)
                                    .foregroundColor(taskName.isEmpty && tasks.currentSelectedTask == nil ? .gray : tasks.isLogging ? .red : Color(hex: "3b6978"))
                                    .padding(.horizontal, 25)
                            }
                            
                            
                            
                        }
                        //                        Button(action: { self.buttonPressed() }) {
                        //                            (tasks.isLogging ? SFSymbols.stopButton : SFSymbols.playButton)
                        //                                .font(.largeTitle)
                        //                                .foregroundColor(taskName.isEmpty && tasks.currentSelectedTask == nil ? .gray : tasks.isLogging ? .red : .green)
                        //                                .padding(.horizontal, 25)
                        //                        }
                        //                        .disabled(taskName.isEmpty && tasks.currentSelectedTask == nil)
                    }
                    
                    if tasks.isLogging {
                        TimeDisplay(logRecordStartTime: tasks.currentSelectedTask?.loggingHistory.last?.startTime ?? Date())
                    }
                    if tasks.isLogging {
                        HStack {
                            Button(action: { withAnimation { self.tasks.discardInFlightLoggingRecord() } }) {
                                Text("Discard").font(.caption)
                            }.padding()
                            if !showingPomodoroTimer {
                                Button(action: { withAnimation { self.showingPomodoroTimer.toggle() } }) {
                                    Text("Add pomodoro").font(.caption)
                                }.padding()
                                
                                
                            }
                        }
                        
                        
                    }
                    if self.showingPomodoroTimer {
                        PomodoroView(showingPomodoroView: $showingPomodoroTimer).padding().layoutPriority(1)
                    }
                }
            }
        }
        .frame(minHeight: 150)
        .padding(30)
        .background(Color.white).cornerRadius(16)
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
            if self.tasks.isLogging {
                let notificationManager = NotificationManager.shared
                if let currentTask = self.tasks.currentSelectedTask {
                    notificationManager.scheduleTimerStillRunningNotification(for: currentTask.name)
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            NotificationManager.shared.cancelAllNotificaitons()
            if let currentTask = self.tasks.currentSelectedTask {                
                guard let currentLoggingRecord = currentTask.loggingHistory.last else { return }
                guard currentLoggingRecord.endTime == nil else { return }
            }
        }
    }
    
    func buttonPressed() {
        UIApplication.shared.endEditing()
        if tasks.isLogging {
            withAnimation {
                tasks.stopLoggingForCurrentTask()
                self.showingPomodoroTimer = false
            }
        } else {
            if tasks.currentSelectedTask == nil {
                withAnimation { tasks.startLoggingForNewTask(named: self.taskName) }
                self.taskName = ""
            } else {
                withAnimation { tasks.startLoggingForCurrentTask() }
            }
        }
    }
    
    
}

struct TimerCardView_Previews: PreviewProvider {
    static var previews: some View {
        TimerCardView(tasks: TasksViewModel())
            .previewLayout(.sizeThatFits)
    }
}
