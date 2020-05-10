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
    
    @State private var isFullScreenMod = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                VStack {
                    ZStack {
                        // Display when a task is selected
                        if tasks.currentSelectedTask == nil {
                            VStack {
                                TextField("New task", text: $taskName).font(.title).multilineTextAlignment(.center)
                                Rectangle().fill(Color.gray).frame(height: 1)
                                
                                if !taskName.isEmpty && tasks.currentSelectedTask == nil {
                                    Button(action: { self.buttonPressed() }) {
                                        SFSymbols.playButton
                                            .font(.largeTitle)
                                            .foregroundColor(Color(hex: "3b6978"))
                                    }
                                    .animation(.default)
                                    .transition(.move(edge: .trailing))
                                    .padding()
                                }
                                
                            }
                            
                        } else {
                            Text(tasks.currentSelectedTask?.name ?? "Error").font(.title)
                        }

                    }
                    
                    if tasks.isLogging {
                        ZStack {
                            TimeDisplay(logRecordStartTime: tasks.currentSelectedTask?.loggingHistory.last?.startTime ?? Date())
                            
                            HStack {
                                Spacer()
                                // Display that hides the play button until either a task is selected or the user starts typing
                                Button(action: { self.buttonPressed() }) {
                                    SFSymbols.stopButton
                                        .font(.largeTitle)
                                        .foregroundColor(.red)
                                }
                                .animation(.default)
                                .transition(.move(edge: .trailing))
                                .padding(.bottom)
                                .padding(.trailing, 50)
                            }
                            
                            
                            
                        }
                    }
                    if tasks.isLogging {
                        
                        
                        if !showingPomodoroTimer {
                            Button(action: { withAnimation { self.showingPomodoroTimer.toggle() } }) {
                                Text("Add pomodoro").font(.caption)
                            }.padding()
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
