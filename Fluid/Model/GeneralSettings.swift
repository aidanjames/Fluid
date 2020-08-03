//
//  File.swift
//  Fluid
//
//  Created by Aidan Pendlebury on 03/08/2020.
//  Copyright © 2020 Aidan Pendlebury. All rights reserved.
//

import Foundation

enum GeneralSettings {
    static var preventScreenLock: Bool = false
    
    static func persistSettings() {
        print("I'm about to save the settings")
        let settings = [self.preventScreenLock]
        FileManager.default.writeData(settings, to: FMKeys.generalSettings)
    }
    
}
