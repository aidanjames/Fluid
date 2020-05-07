//
//  TimeDisplay.swift
//  Fluid
//
//  Created by Aidan Pendlebury on 07/05/2020.
//  Copyright © 2020 Aidan Pendlebury. All rights reserved.
//

import SwiftUI

struct TimeDisplay: View {
    
    var logRecordStartTime: Date
    
    @State private var timeSinceStart = "< 1min"
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Text(timeSinceStart)
        .onReceive(timer) { _ in
            self.setTimeDisplay()
        }
        .onAppear {
            self.setTimeDisplay()
        }
    }
    
    func setTimeDisplay() {
        let counter = Int(Date().timeIntervalSince(self.logRecordStartTime))
        guard counter > 59 else { return }
        self.timeSinceStart = counter.secondsToHoursMins()
    }
}

struct TimeDisplay_Previews: PreviewProvider {
    static var previews: some View {
        TimeDisplay(logRecordStartTime: Date())
    }
}
