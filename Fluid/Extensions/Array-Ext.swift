//
//  Array-Ext.swift
//  Fluid
//
//  Created by Aidan Pendlebury on 30/04/2020.
//  Copyright © 2020 Aidan Pendlebury. All rights reserved.
//

import Foundation

extension Array {
    
    mutating func move(from oldPosition: Int, to newPosition: Int) {
        let element = self.remove(at: oldPosition)
        self.insert(element, at: newPosition)
    }
    
}
