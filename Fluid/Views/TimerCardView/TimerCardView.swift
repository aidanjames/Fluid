//
//  TimerCardView.swift
//  Fluid
//
//  Created by Aidan Pendlebury on 26/04/2020.
//  Copyright © 2020 Aidan Pendlebury. All rights reserved.
//

import SwiftUI

struct TimerCardView: View {
    
    @ObservedObject var timer = MyTimer.shared
    @State private var taskName = ""
    
    var tasks: TasksViewModel
    @Binding var currentSelectedTask: Task?
    @State private var currentLoggingRecord: LoggingRecord?
    var buttonDisabled: Bool { return taskName.isEmpty && currentSelectedTask == nil }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                VStack(alignment: .trailing) {
                    HStack {
                        VStack(alignment: .leading, spacing: 0) {
                            if currentSelectedTask == nil {
                                TextField("Task", text: $taskName)
                                Rectangle().fill(Color.gray).frame(height: 1)
                            } else {
                                Text(currentSelectedTask?.name ?? "Error")
                                Rectangle().fill(Color.gray).frame(height: 1).opacity(0)
                                if timer.isCounting {
                                    Button("Discard") {
                                        self.timer.stopTimer()
                                        self.taskName = ""
                                        self.currentSelectedTask = nil
                                        self.currentLoggingRecord = nil
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 25)
                        .padding(.top)
                        Spacer()
                        Button(action: { self.buttonPressed() }) {
                            Image(systemName: timer.isCounting ? SFSymbols.stopButton : SFSymbols.playButton)
                                .font(.largeTitle)
                                .foregroundColor(buttonDisabled ? .gray : timer.isCounting ? .red : .green)
                                .padding(.horizontal, 25)
                        }.disabled(buttonDisabled)
                    }
                    HStack {
//                        LottieView(filename: LottieAnimations.tickingClock).frame(width: 50, height: 50).padding(0)
                        Text(timer.counter.secondsToHoursMinsSecs()).font(.body).padding(.trailing, 25).padding(.vertical)
                    }
                }
            }
            ProgressBarView(counter: $timer.counter, maxCounter: timer.maxCounter)
                .frame(height: 10)
                .padding(.horizontal, 25)
        }
        .padding(30)
        .background(Color.white).cornerRadius(40)
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
            if self.currentLoggingRecord != nil {
                self.timer.stopTimer()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            if self.currentLoggingRecord != nil {
                self.timer.counter = Int(Date().timeIntervalSince(self.currentLoggingRecord!.startTime))
                self.timer.startTimer()
            }
        }
    }
    
    func buttonPressed() {
        UIApplication.shared.endEditing()
        
        if timer.isCounting {
            UIApplication.shared.isIdleTimerDisabled = false
            timer.stopTimer()
            self.finishLoggingRecord()
        } else {
             UIApplication.shared.isIdleTimerDisabled = true
            timer.maxCounter = 1500
            timer.startTimer()
            if currentSelectedTask == nil {
                self.addNewTask()
            } else {
                self.startLoggingRecord()
            }
        }
    }
    
    func addNewTask() {
        let task = Task(name: taskName, loggingHistory: [])
        self.currentSelectedTask = task
        self.startLoggingRecord()
    }
    
    func startLoggingRecord() {
        guard self.currentSelectedTask != nil else { fatalError("You've made a mistake we shouldn't be able to add a logging record without a task.") }
        let newLoggingRecord = LoggingRecord(taskID: self.currentSelectedTask!.id, startTime: Date(), endTime: nil)
        self.currentLoggingRecord = newLoggingRecord
    }
    
    func finishLoggingRecord() {
        guard self.currentLoggingRecord != nil, self.currentSelectedTask != nil else { fatalError("You've made a mistake.")}
        
        if let index = self.tasks.allTasks.firstIndex(where: { $0.id == currentSelectedTask?.id } ) {
            // This is an existing task
            self.currentLoggingRecord?.endTime = Date()
            self.tasks.allTasks[index].loggingHistory.append(currentLoggingRecord!)
        } else {
            // This is a new task
            self.currentLoggingRecord?.endTime = Date()
            self.currentSelectedTask?.loggingHistory.append(currentLoggingRecord!)
            withAnimation {
                self.tasks.allTasks.insert(self.currentSelectedTask!, at: 0)
            }
            
        }

        FileManager.default.writeData(self.tasks.allTasks, to: FMKeys.allTasks)
        self.taskName = ""
        self.currentSelectedTask = nil
        self.currentLoggingRecord = nil
        
    }
}

struct TimerCardView_Previews: PreviewProvider {
    static var previews: some View {
        TimerCardView(tasks: TasksViewModel(), currentSelectedTask: .constant(nil))
            .previewLayout(.sizeThatFits)
    }
}
