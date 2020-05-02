//
//  LoggingRecord.swift
//  Fluid
//
//  Created by Aidan Pendlebury on 02/05/2020.
//  Copyright © 2020 Aidan Pendlebury. All rights reserved.
//

import Foundation

class LoggingRecord: Codable {
    var taskID: UUID
    var startTime: Date
    var endTime: Date?
    
    var lengthInSeconds: Int {
        guard let endTime = self.endTime else { return 0 }
        let time = endTime.timeIntervalSince(startTime)
        return Int(time)
    }
    
    
    init(taskID: UUID, endTime: Date? = nil) {
        self.taskID = taskID
        self.startTime = Date()
        self.endTime = endTime
    }
}
