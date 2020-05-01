//
//  UIApplication-Ext.swift
//  Fluid
//
//  Created by Aidan Pendlebury on 29/04/2020.
//  Copyright © 2020 Aidan Pendlebury. All rights reserved.
//

import UIKit

extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func startEditing() {
        sendAction(#selector(UIResponder.becomeFirstResponder), to: nil, from: nil, for: nil)
    }
}
