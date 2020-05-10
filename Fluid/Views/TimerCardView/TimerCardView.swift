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
    
    @Binding var showingFullScreen: Bool
    
    
    var body: some View {
        VStack {
            VStack {
                ZStack {

                    if tasks.currentSelectedTask == nil {
                        VStack {
                            TextField("Add new task", text: $taskName).font(.title).multilineTextAlignment(.center)
                            Rectangle().fill(Color.gray).frame(height: 1).padding(.horizontal, 50)
                            
                            if !taskName.isEmpty && tasks.currentSelectedTask == nil {
                                Button(action: { self.buttonPressed() }) {
                                    ButtonView(buttonText: "Start timer", backgroundColour: Color(Colours.midnightBlue), maxWitdh: 120)
                                }
                                .animation(.default)
                                .transition(.move(edge: .trailing))
                                .padding()
                            }
                        }
                        
                    } else {
                        Text(tasks.currentSelectedTask?.name ?? "Error").font(.title).bold().padding(.top).foregroundColor(Color(Colours.midnightBlue))
                    }
                }
                
                if tasks.isLogging {
                    ZStack {
                        TimeDisplay(logRecordStartTime: tasks.currentSelectedTask?.loggingHistory.last?.startTime ?? Date())
                        LottieView(filename: "clockCoral").frame(width: 80, height: 80).offset(x: 100, y: -5)
                    }
                }
                if tasks.isLogging {
                    
                    HStack {
                        if !showingPomodoroTimer {
                            Button(action: { withAnimation { self.showingPomodoroTimer.toggle() } }) {
                                ButtonView(buttonText: "Add pomodoro", backgroundColour: Color(Colours.midnightBlue), maxWitdh: 120)
                            }
                            .padding(.leading, 45)
                            Spacer()
                        }
                        Button(action: { self.buttonPressed() }) {
                            ButtonView(buttonText: "End timer", backgroundColour: Color(Colours.hotCoral), maxWitdh: 120)
                        }.padding(.trailing, showingPomodoroTimer ? 0 : 45)
                        
                        
                        
                    }.padding(.bottom, 20)
                 
                    if self.showingPomodoroTimer {
                        HStack {
                            Spacer()
                            PomodoroView(showingPomodoroView: $showingPomodoroTimer).padding().layoutPriority(1)
                            Spacer()
                        }.padding(.bottom)
                        
                    }
                    
                }

            }
        }
            //        .frame(width: self.showingFullScreen ? screen.width : screen.width - 32, height: self.showingFullScreen ? screen.height : 200)
            .frame(minHeight: self.showingFullScreen ? screen.height : 200)
            .background(Color.white).cornerRadius(16)
            .padding(.horizontal, self.showingFullScreen ? 0 : 16)
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
                //                self.showingFullScreen = false
            }
        } else {
            //            withAnimation { showingFullScreen = true }
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
        TimerCardView(tasks: TasksViewModel(), showingFullScreen: .constant(false))
            .previewLayout(.sizeThatFits)
    }
}
