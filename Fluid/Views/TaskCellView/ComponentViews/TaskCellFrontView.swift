//
//  TaskCellView-Front.swift
//  Fluid
//
//  Created by Aidan Pendlebury on 30/04/2020.
//  Copyright © 2020 Aidan Pendlebury. All rights reserved.
//

import SwiftUI

struct TaskCellFrontView: View {
    
    var task: Task
    @ObservedObject var tasks: TasksViewModel
    @Binding var showingFront: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(task.name).font(.body).bold().foregroundColor(Color(Colours.midnightBlue)).padding(.bottom, 5)
                Text("Today: \(task.getSecondsRecordedToday().secondsToHoursMins())").foregroundColor(.secondary)
                Text("This week: \(task.getSecondsRecordedThisWeek().secondsToHoursMins())").foregroundColor(.secondary)
                Text("This month: \(task.getSecondsRecordedThisMonth().secondsToHoursMins())").foregroundColor(.secondary)
                Text("All time: \(task.getSecondsRecordedAllTime().secondsToHoursMins())").foregroundColor(.secondary)
            }.font(.footnote)
            
            
            Spacer()
            Button(action: {
                withAnimation { self.showingFront.toggle() }
            }) {
                SFSymbols.moreButtonWithoutCircle
                    .foregroundColor(tasks.currentSelectedTask == nil ? Color(Colours.midnightBlue) : .gray)
                    .font(.largeTitle).padding(5)
            }
            Button(action: {
                self.tasks.currentSelectedTask = self.task
                self.tasks.isLogging = true
                self.tasks.startLoggingForCurrentTask()
                if let index = self.tasks.allTasks.firstIndex(where: { $0.id == self.task.id }) {
                    withAnimation { self.tasks.allTasks.move(from: index, to: 0) }
                }
            }) {
                SFSymbols.playButton.foregroundColor(tasks.currentSelectedTask == nil ? Color(Colours.midnightBlue) : .gray).font(.largeTitle).padding(5)
            }
        }.blur(radius: tasks.isLogging ? 0.5 : 0)
    }
}

struct TaskCellView_Front_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TaskCellFrontView(task: PreviewMockData.task, tasks: PreviewMockData.tasks, showingFront: .constant(true))
                .padding()
                .previewLayout(.sizeThatFits)
            TaskCellFrontView(task: PreviewMockData.task, tasks: PreviewMockData.tasks, showingFront: .constant(true))
            .padding()
            .previewLayout(.sizeThatFits)
        }
    }
}
