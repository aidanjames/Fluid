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
        
        
        GeometryReader { geo in
            VStack {
                
                Picker("", selection: self.$periodFilter) {
                    ForEach(0..<self.filterPeriods.count) {
                        Text("\(self.filterPeriods[$0])").font(.caption)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                if self.filteredLogRecords.isEmpty {
                    Text("No activity :(").font(.caption)
                } else {
                    HStack(alignment: .bottom) {
                        ForEach(self.filteredLogRecords) { record in
                            BarView(width: self.calculateBarWidth(forSize: geo.size.width), height: self.caluculateBarHeight(forSeconds: record.lengthInSeconds), taskName: record.lengthInSeconds.secondsToHoursMins(), timeText: "")
                        }
                    }.padding(.horizontal)
                }
                

                Spacer()
                //            ForEach(filteredLogRecords) { record in
                //                Text("\(record.startTime)").font(.caption)
                //            }
            }
        }
    }
    
    func calculateBarWidth(forSize widthAvailable: CGFloat) -> CGFloat {
        let calculatedBarWidth = (widthAvailable / CGFloat(self.filteredLogRecords.count)) / 5
        
        return calculatedBarWidth > 10 ? CGFloat(10) : calculatedBarWidth
    }
    
    func caluculateBarHeight(forSeconds seconds: Int) -> CGFloat {
        let max = filteredLogRecords.map { $0.lengthInSeconds }.max()
        
        return CGFloat(seconds) / CGFloat(max!) * 150
    }
    
    
}

struct SingleTaskGraphView_Previews: PreviewProvider {
    static var previews: some View {
        SingleTaskGraphView(task: PreviewMockData.task)
    }
}
