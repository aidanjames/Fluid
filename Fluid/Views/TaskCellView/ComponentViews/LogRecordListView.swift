//
//  LogRecordListView.swift
//  Fluid
//
//  Created by Aidan Pendlebury on 03/05/2020.
//  Copyright © 2020 Aidan Pendlebury. All rights reserved.
//

import SwiftUI

struct LogRecordListView: View {
    
    @ObservedObject var tasks: TasksViewModel
    var taskID: UUID?
    var task: Task?
    
    var logHistory: [LoggingRecord] {
        // If we have a taskID, let's get the index for the task
        if let taskID = taskID {
            if let taskIndex = tasks.allTasks.firstIndex(where: { $0.id == taskID }) {
                // Now let's return the logging history for that task
                return tasks.allTasks[taskIndex].loggingHistory
            }
        }
        // If we're here, we'll just return all the tasks (future use)
        var returnArray = [LoggingRecord]()
        for task in tasks.allTasks {
            for logRecord in task.loggingHistory {
                returnArray.append(logRecord)
            }
        }
        return returnArray
    }

    
    var recordsGroupedByDate: [Date: [LoggingRecord]] { Dictionary.init(grouping: logHistory, by: { $0.startTime.startOfToday }) }
    
    
    var uniqueDates: [Date] { recordsGroupedByDate.map({ $0.key }).sorted() }
    
    var body: some View {
        ScrollView {
            ForEach(uniqueDates.reversed(), id: \.self) { date in
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(date.dateAsFriendlyString) - \(getTotalFor(date: date))").font(.caption).bold().foregroundColor(Color(Colours.midnightBlue))
                        .padding(.top, 8)
                    ForEach(recordsGroupedByDate[date]!.reversed()) { record in
                        LogRecordListItemView(tasks: tasks, record: record)
                    }
                }
            }
            Spacer()
        }
        .frame(minHeight: 150)
    }
    
    func getTotalFor(date: Date) -> String {
        logHistory.filter { $0.startTime.startOfToday == date }.reduce(0) { $0 + $1.lengthInSeconds}.secondsToHoursMins()
    }
    
}

struct LogRecordListView_Previews: PreviewProvider {
    static var previews: some View {
        LogRecordListView(tasks: PreviewMockData.tasks, taskID: PreviewMockData.task.id, task: PreviewMockData.task)
        .padding()
            .previewLayout(.sizeThatFits)
    }
}
