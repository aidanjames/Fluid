//
//  View-Ext.swift
//  Fluid
//
//  Created by Aidan Pendlebury on 12/05/2020.
//  Copyright © 2020 Aidan Pendlebury. All rights reserved.
//

import SwiftUI

extension View {
    
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
    
}
