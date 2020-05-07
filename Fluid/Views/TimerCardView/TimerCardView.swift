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
    @ObservedObject var tasks: TasksViewModel
    
    // Attempt to move away from the shared timer.
    let taskTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var taskName = ""
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                VStack(alignment: .trailing) {
                    HStack {
                        VStack(alignment: .leading, spacing: 0) {
                            if tasks.currentSelectedTask == nil {
                                TextField("Task", text: $taskName)
                                Rectangle().fill(Color.gray).frame(height: 1)
                            } else {
                                Text(tasks.currentSelectedTask?.name ?? "Error")
                                Rectangle().fill(Color.gray).frame(height: 1).opacity(0)
                                if timer.isCounting {
                                    Button("Discard") {
                                        withAnimation { self.tasks.discardInFlightLoggingRecord() }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 25)
                        .padding(.top)
                        Spacer()
                        Button(action: { self.buttonPressed() }) {
                            (timer.isCounting ? SFSymbols.stopButton : SFSymbols.playButton)
                                .font(.largeTitle)
                                .foregroundColor(taskName.isEmpty && tasks.currentSelectedTask == nil ? .gray : timer.isCounting ? .red : .green)
                                .padding(.horizontal, 25)
                        }
                        .disabled(taskName.isEmpty && tasks.currentSelectedTask == nil)
                    }
                    Text(timer.counter < 60 ? "< 1min" : "\(timer.counter.secondsToHoursMins())").padding(.trailing, 25)
                    Text("New time")
                }
            }
            ProgressBarView(counter: $timer.counter, maxCounter: timer.maxCounter)
                .frame(height: 10)
                .padding(.horizontal, 25)
        }
        .padding(30)
        .background(Color.white).cornerRadius(40)
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
            if self.timer.isCounting {
                self.timer.stopTimer()
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
                self.timer.counter = Int(Date().timeIntervalSince(currentLoggingRecord.startTime))
                self.timer.startTimer()
            }
        }
    }
    
    func buttonPressed() {
        UIApplication.shared.endEditing()
        if timer.isCounting {
            withAnimation { tasks.stopLoggingForCurrentTask() }
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
