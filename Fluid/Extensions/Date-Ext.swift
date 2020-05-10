//
//  Date-Ext.swift
//  Fluid
//
//  Created by Aidan Pendlebury on 02/05/2020.
//  Copyright © 2020 Aidan Pendlebury. All rights reserved.
//

import Foundation

extension Date {
    
    var startOfThisWeek: Date? {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())
        return calendar.date(from: components)
        
        // I'm can't recall why I had the below in here. It adds a day then returns the start of the week.
        // I've removed it for now but I'm sure it was there to solve some edge case so this might come back to haunt me...
        
//        return calendar.date(byAdding: .day, value: 1, to: calendar.date(from: components)!)
    }
    
    var startOfThisMonth: Date? {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components)
    }
    
    var startOfToday: Date {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        return calendar.date(from: components) ?? Date()
    }
    
    var dateAsString: String {        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: self)
    }
    
    var dateAsFriendlyString: String {
        let calendar = Calendar(identifier: .gregorian)
        if calendar.isDateInToday(self) { return "Today"}
        if calendar.isDateInYesterday(self) { return "Yesterday" }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: self)
    }
    
    var timeFromDateAsString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }

    
}
