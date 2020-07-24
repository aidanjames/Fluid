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
    
    @State private var hoursSinceStart = "00"
    @State private var minutesSinceStart = "00"
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                VStack {
                    Text(hoursSinceStart).foregroundColor(Color(Colours.midnightBlue))
                    Text("Hours").font(.caption).foregroundColor(.secondary)
                }
                Text(":")
                VStack {
                    Text(minutesSinceStart).foregroundColor(Color(Colours.midnightBlue))
                    Text("Minutes").font(.caption).foregroundColor(.secondary)
                }
            }.font(.largeTitle)
        }
        .onReceive(timer) { _ in
            setTimeDisplay()
        }
        .onAppear {
            setTimeDisplay()
        }
    }
    
    func setTimeDisplay() {
        let counter = Int(Date().timeIntervalSince(logRecordStartTime))
        let splitHoursAndSeconds = counter.secondsToHoursMinsSpit()
        hoursSinceStart = splitHoursAndSeconds.hours
        minutesSinceStart = splitHoursAndSeconds.mins
    }
}

struct TimeDisplay_Previews: PreviewProvider {
    static var previews: some View {
        TimeDisplay(logRecordStartTime: Date().startOfToday)
    }
}
