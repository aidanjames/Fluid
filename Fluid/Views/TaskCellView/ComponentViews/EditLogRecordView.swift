//
//  EditLogRecordView.swift
//  Fluid
//
//  Created by Aidan Pendlebury on 05/05/2020.
//  Copyright © 2020 Aidan Pendlebury. All rights reserved.
//

import SwiftUI

struct EditLogRecordView: View {
    
    var logRecord: LoggingRecord
    @ObservedObject var tasks: TasksViewModel
    
    @State private var taskName = ""
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var editingStartTime = false
    @State private var editingEndTime = false
    
    var dynamicLogRecordTime: String {
        let time = endTime.timeIntervalSince(startTime)
        return Int(time).secondsToHoursMins()
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Text("\(taskName) (\(dynamicLogRecordTime))").bold()
                Section(header: Text("Edit start/end time")) {
                    DatePicker("Edit start time", selection: $startTime)
                    DatePicker("Edit end time", selection: $endTime)
                }
                
            }
            .navigationBarTitle("Edit record", displayMode: .inline)
            .navigationBarItems(
                leading:
                Button("Cancel") { presentationMode.wrappedValue.dismiss() },
                trailing:
                Button("Save") { saveChanges() }.disabled(startTime > endTime)
            )
                .onAppear(perform: configureUI)
        }
    }
    
    func configureUI() {
        
        if let index = tasks.allTasks.firstIndex(where: { $0.id == logRecord.taskID }) {
            taskName = tasks.allTasks[index].name
        }
        startTime = logRecord.startTime
        if let endTime = logRecord.endTime {
            self.endTime = endTime
        }
    }
    
    func saveChanges() {
        tasks.update(logRecord: logRecord, startTime: startTime, endTime: endTime)
        presentationMode.wrappedValue.dismiss()
    }
    
}

struct EditLogRecordView_Previews: PreviewProvider {
    static var previews: some View {
        EditLogRecordView(logRecord: PreviewMockData.loggingRecord, tasks: PreviewMockData.tasks)
    }
}
