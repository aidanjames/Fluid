//
//  LogRecordListItemView.swift
//  Fluid
//
//  Created by Aidan Pendlebury on 04/05/2020.
//  Copyright © 2020 Aidan Pendlebury. All rights reserved.
//

import SwiftUI

struct LogRecordListItemView: View {
    
    @ObservedObject var tasks: TasksViewModel
    var record: LoggingRecord
    
    @State private var showingAlert = false
    @State private var showingEditRecord = false
    
    var body: some View {
        HStack {
            Text("\(record.startTime.timeFromDateAsString) -> \(record.endTime?.timeFromDateAsString ?? "Active record") (\(record.lengthInSeconds.secondsToHoursMins()))").font(Font.system(.caption).monospacedDigit()).foregroundColor(Color(Colours.midnightBlue))
            Spacer()
            Button(action: { self.showingEditRecord.toggle() }) {
                Text("Edit")
                .font(.caption)
                .foregroundColor(.white)
                .padding(.horizontal)
                .padding(.vertical, 3)
                .background(Color(Colours.midnightBlue))
                .cornerRadius(16)
            }
            .sheet(isPresented: $showingEditRecord) {
                EditLogRecordView(logRecord: self.record, tasks: self.tasks)
            }
            Button(action: { self.showingAlert.toggle() }) {
                Text("Delete")
                .font(.caption)
                .foregroundColor(.white)
                .padding(.horizontal)
                .padding(.vertical, 3)
                .background(Color(Colours.hotCoral))
                .cornerRadius(16)
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Delete record?"), message: Text("Are you sure you want to delete this record? This cannot be undone."),
                      primaryButton: .destructive(Text("Delete")) { self.tasks.delete(loggingRecord: self.record)},
                      secondaryButton: .cancel()
                )
            }
        }
    }
}

struct LogRecordListItemView_Previews: PreviewProvider {
    static var previews: some View {
        LogRecordListItemView(tasks: PreviewMockData.tasks, record: PreviewMockData.loggingRecord)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
