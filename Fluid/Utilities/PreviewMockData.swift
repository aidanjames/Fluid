//
//  PreviewMockData.swift
//  Fluid
//
//  Created by Aidan Pendlebury on 30/04/2020.
//  Copyright © 2020 Aidan Pendlebury. All rights reserved.
//

import Foundation

enum PreviewMockData {
    
//    static let task = Task(name: "Meeting", loggingHistory: [
//                                                                LoggingRecord(taskID: UUID(), endTime: Date().addingTimeInterval(6000)),
//                                                                LoggingRecord(taskID: UUID(), endTime: Date().addingTimeInterval(6500)),
//                                                                LoggingRecord(taskID: UUID(), endTime: Date().addingTimeInterval(666500))
//                                                            ])
    static let task = Task(name: "Meeting", loggingHistory: PreviewMockData.makeMeABunchOfLoggingRecords())
    static let loggingRecord = LoggingRecord(taskID: UUID(), endTime: Date().addingTimeInterval(19))
    static let tasks = TasksViewModel(tasks: [task])
    
    
    static func makeMeABunchOfLoggingRecords() -> [LoggingRecord] {
        var returnArray = [LoggingRecord]()
        for _ in 1...10 {
            let newRecord = LoggingRecord(taskID: UUID(), endTime: Date().addingTimeInterval(TimeInterval.random(in: 0...10000)))
            newRecord.startTime = Date().addingTimeInterval(TimeInterval.random(in: -10000...0))
            returnArray.append(newRecord)
        }
        return returnArray
    }
    
}
