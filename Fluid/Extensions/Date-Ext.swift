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
        guard let thisTimeLastWeek = calendar.date(byAdding: .day, value: -7, to: self) else { return nil }
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: thisTimeLastWeek)
        return calendar.date(byAdding: .day, value: 1, to: calendar.date(from: components)!)
    }
    
    var startOfThisMonth: Date? {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components)
    }
    
    var dateAsString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: self)
    }
    
    var timeFromDateAsString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: self)
    }

}
