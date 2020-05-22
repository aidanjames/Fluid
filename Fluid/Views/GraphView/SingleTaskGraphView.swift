//
//  GraphView.swift
//  Fluid
//
//  Created by Aidan Pendlebury on 22/05/2020.
//  Copyright © 2020 Aidan Pendlebury. All rights reserved.
//

import SwiftUI

struct SingleTaskGraphView: View {
    
    var task: Task
    
    var filteredLogRecords: [LoggingRecord] { task.loggingHistory.filter {
        $0.startTime > (periodFilter == 0 ? Date().startOfToday : periodFilter == 1 ? Date().startOfThisWeek! : Date().startOfThisMonth!)
        }}
    
    let filterPeriods = ["Today", "This week", "This month"]
    
    // Future use
    var recordsGroupedByDate: [Date: [LoggingRecord]] { Dictionary.init(grouping: filteredLogRecords, by: { $0.startTime }) }
    var uniqueDates: [Date] { recordsGroupedByDate.map({ $0.key }).sorted() }
    
    @State private var periodFilter = 0
    
    var body: some View {
        VStack {
            
            Picker("Filter", selection: $periodFilter) {
                ForEach(0..<filterPeriods.count) {
                    Text("\(self.filterPeriods[$0])")
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            
            ForEach(filteredLogRecords) { record in
                Text("\(record.startTime)").font(.caption)
            }
        }
        .padding(.bottom)
    }
    
    
}

struct SingleTaskGraphView_Previews: PreviewProvider {
    static var previews: some View {
        SingleTaskGraphView(task: PreviewMockData.task)
    }
}
