//
//  Task.swift
//  Fluid
//
//  Created by Aidan Pendlebury on 28/04/2020.
//  Copyright © 2020 Aidan Pendlebury. All rights reserved.
//

import Foundation

struct Task: Identifiable, Codable {
    var id = UUID()
    var name: String
    var loggingHistory: [LoggingRecord]
    var totalTimeInSeconds: Int { return loggingHistory.reduce(0) { $0 + $1.lengthInSeconds} }
    
    init(name: String, loggingHistory: [LoggingRecord]) {
        self.name = name
        self.loggingHistory = loggingHistory
    }
}




