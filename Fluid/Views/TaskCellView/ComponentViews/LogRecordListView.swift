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
        // If we're here, we'll just return all the tasks
        var returnArray = [LoggingRecord]()
        for task in tasks.allTasks {
            for logRecord in task.loggingHistory {
                returnArray.append(logRecord)
            }
        }
        return returnArray
    }
    
    
    var recordsGroupedByDate: [String: [LoggingRecord]] {
        Dictionary.init(grouping: logHistory, by: { $0.dateString })
    }
    
    
    var uniqueDates: [String] {
        recordsGroupedByDate.map({ $0.key }).sorted()
    }
    
    
    var body: some View {
        List {
            ForEach(uniqueDates, id: \.self) { date in
                Section(header: Text(date)) {
                    ForEach(self.recordsGroupedByDate[date]!) { record in
                        HStack {
                            Text("From \(record.startTime.timeFromDateAsString)")
                            Text("-> \(record.endTime?.timeFromDateAsString ?? "Active record")")
                            Spacer()
                            Button("Edit") { withAnimation { self.tasks.delete(loggingRecord: record) } }
                                .foregroundColor(.blue)
                            Button("Delete") { withAnimation {  } }
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .font(.caption)
        }
//        .listStyle(GroupedListStyle())
    }
}

struct LogRecordListView_Previews: PreviewProvider {
    static var previews: some View {
        LogRecordListView(tasks: PreviewMockData.tasks, taskID: PreviewMockData.task.id, task: PreviewMockData.task)
            .previewLayout(.sizeThatFits)
    }
}
