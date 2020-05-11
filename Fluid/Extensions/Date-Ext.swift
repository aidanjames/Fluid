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
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2 // So week starts from midnight at the start of Monday morning (i.e. midnight Sunday)
        return calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
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
