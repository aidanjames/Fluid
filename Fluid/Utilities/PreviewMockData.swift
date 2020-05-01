//
//  PreviewMockData.swift
//  Fluid
//
//  Created by Aidan Pendlebury on 30/04/2020.
//  Copyright © 2020 Aidan Pendlebury. All rights reserved.
//

import Foundation

enum PreviewMockData {
    
    static let task = Task(name: "Meeting", loggingHistory: [LoggingRecord(taskID: UUID(), startTime: Date(), endTime: Date().addingTimeInterval(6000))])
    static let loggingRecord = LoggingRecord(taskID: UUID(), startTime: Date(), endTime: Date().addingTimeInterval(19))
    static let tasks = Tasks(tasks: [task])
    
}
