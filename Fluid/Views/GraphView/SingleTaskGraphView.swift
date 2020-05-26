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
    
    var timeSpentByWeek: [Int] {
        if periodFilter == 0 {
            return timesThisWeek()
        } else {
            return timesPreviousWeek()
        }
    }
    
    
    
    
    let dayOfWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    let filterPeriods = ["This week", "Last week"]
    @State private var periodFilter = 0
    
    var body: some View {
        VStack {
            Picker("", selection: self.$periodFilter) {
                ForEach(0..<self.filterPeriods.count) {
                    Text("\(self.filterPeriods[$0])").font(.caption)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
//            Spacer()
            
            HStack(alignment: .bottom, spacing: 5) {
                // Would use a ForEach but animation doesn't work
                BarView(width: 10, height: self.caluculateBarHeight(forSeconds: self.timeSpentByWeek[0]), taskName: "", timeText: self.timeSpentByWeek[0].secondsToHoursMins(), bottomLabel: "Mon")
                BarView(width: 10, height: self.caluculateBarHeight(forSeconds: self.timeSpentByWeek[1]), taskName: "", timeText: self.timeSpentByWeek[1].secondsToHoursMins(), bottomLabel: "Tue")
                BarView(width: 10, height: self.caluculateBarHeight(forSeconds: self.timeSpentByWeek[2]), taskName: "", timeText: self.timeSpentByWeek[2].secondsToHoursMins(), bottomLabel: "Wed")
                BarView(width: 10, height: self.caluculateBarHeight(forSeconds: self.timeSpentByWeek[3]), taskName: "", timeText: self.timeSpentByWeek[3].secondsToHoursMins(), bottomLabel: "Thu")
                BarView(width: 10, height: self.caluculateBarHeight(forSeconds: self.timeSpentByWeek[4]), taskName: "", timeText: self.timeSpentByWeek[4].secondsToHoursMins(), bottomLabel: "Fri")
                BarView(width: 10, height: self.caluculateBarHeight(forSeconds: self.timeSpentByWeek[5]), taskName: "", timeText: self.timeSpentByWeek[5].secondsToHoursMins(), bottomLabel: "Sat")
                BarView(width: 10, height: self.caluculateBarHeight(forSeconds: self.timeSpentByWeek[6]), taskName: "", timeText: self.timeSpentByWeek[6].secondsToHoursMins(), bottomLabel: "Sun")
            }
            .animation(.default)
            
        }
        .frame(minHeight: 150)
        
    }
    
    
    func caluculateBarHeight(forSeconds seconds: Int) -> CGFloat {
        if seconds < 60 {
            return 0
        }
        
        let total = timesThisWeek() + timesPreviousWeek()
        
        if let max = total.max() {
            if max == seconds {
                return 135
            }
            let ratio = CGFloat(135) / CGFloat(max) // e.g. 120 seconds (max) = 1.125 (ratio)
            let returnValue = CGFloat(seconds) * ratio //* e.g. 100 secconds * 1.125 (ratio) = 112.50
            return returnValue
        }
        return 0
    }
    
    
    func timesThisWeek() -> [Int] {
        getTimesForWeek(loggingHistory: task.loggingHistory.filter { $0.startTime > Date().startOfThisWeek! } )
    }
    
    func timesPreviousWeek() -> [Int] {
        getTimesForWeek(loggingHistory: task.loggingHistory.filter { $0.startTime > Date().addingTimeInterval(-604800).startOfThisWeek! && $0.startTime < Date().startOfThisWeek! } )
    }
    
    func getTimesForWeek(loggingHistory: [LoggingRecord]) -> [Int] {
        var returnArray = [0,0,0,0,0,0,0]
        let calendar = Calendar.init(identifier: .gregorian)
        
        let monday = loggingHistory.filter { calendar.component(.weekday, from: $0.startTime) == 2 }
        let tuesday = loggingHistory.filter { calendar.component(.weekday, from: $0.startTime) == 3 }
        let wednesday = loggingHistory.filter { calendar.component(.weekday, from: $0.startTime) == 4 }
        let thursday = loggingHistory.filter { calendar.component(.weekday, from: $0.startTime) == 5 }
        let friday = loggingHistory.filter { calendar.component(.weekday, from: $0.startTime) == 6 }
        let saturday = loggingHistory.filter { calendar.component(.weekday, from: $0.startTime) == 7 }
        let sunday = loggingHistory.filter { calendar.component(.weekday, from: $0.startTime) == 1 }
        
        returnArray[0] = monday.reduce(0) { $0 + $1.lengthInSeconds }
        returnArray[1] = tuesday.reduce(0) { $0 + $1.lengthInSeconds }
        returnArray[2] = wednesday.reduce(0) { $0 + $1.lengthInSeconds }
        returnArray[3] = thursday.reduce(0) { $0 + $1.lengthInSeconds }
        returnArray[4] = friday.reduce(0) { $0 + $1.lengthInSeconds }
        returnArray[5] = saturday.reduce(0) { $0 + $1.lengthInSeconds }
        returnArray[6] = sunday.reduce(0) { $0 + $1.lengthInSeconds }
        
        return returnArray
    }
    
    
}

struct SingleTaskGraphView_Previews: PreviewProvider {
    static var previews: some View {
        SingleTaskGraphView(task: PreviewMockData.task)
    }
}
