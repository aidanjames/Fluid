//
//  Int-Ext.swift
//  Fluid
//
//  Created by Aidan Pendlebury on 26/04/2020.
//  Copyright © 2020 Aidan Pendlebury. All rights reserved.
//

import Foundation

extension Int {
    
    func secondsToHoursMinsSecs() -> String {
        let hours = self / 3600
        let mins = (self % 3600) / 60
        let secs = (self % 3600) % 60
        
        return hours < 1 ? String(format: "%01d:%02d", mins, secs) : String(format: "%01d:%02d:%02d", hours, mins, secs)
    }
    
    
    func secondsToHoursMins() -> String {
        let hours = self / 3600
        let mins = (self % 3600) / 60
        return String(format: "%01dh %02dm", hours, mins)
    }
    
    
    func secondsToHoursMinsMinimal() -> String {
        let hours = self / 3600
        let mins = (self % 3600) / 60
        return String(format: "%02d : %02d", hours, mins)
    }
    
    
    func secondsToHoursMinsSpit() -> (hours: String, mins: String) {
        let hours = self / 3600
        let mins = (self % 3600) / 60
        
        let hoursReturnValue = String(format: "%02d", hours)
        let minsReturnValue = String(format: "%02d", mins)
        
        return (hours: hoursReturnValue, mins: minsReturnValue)
    }
    
}
