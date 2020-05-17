//
//  Target.swift
//  Fluid
//
//  Created by Aidan Pendlebury on 17/05/2020.
//  Copyright © 2020 Aidan Pendlebury. All rights reserved.
//

import Foundation

enum Period: String, Codable {
    case perDay
    case perWeek
    case perMonth
}

enum TargetType: String, Codable {
    case minimum
    case maximum
}


// These can be linked to a task so a user can say "I want to spend 5 hours on this task per week"
struct Target: Codable {
    let taskID: UUID
    let amount: Int
    let period: Period
    let target: TargetType
}
