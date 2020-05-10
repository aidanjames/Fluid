//
//  RingView.swift
//  Fluid
//
//  Created by Aidan Pendlebury on 08/05/2020.
//  Copyright © 2020 Aidan Pendlebury. All rights reserved.
//

import SwiftUI

struct RingView: View {

    @ObservedObject var pomodoroSession: PomodoroSession
     
    var percent: CGFloat { CGFloat(pomodoroSession.pomodoros[pomodoroSession.currentPomodoro].counter) / CGFloat(pomodoroSession.pomodoros[pomodoroSession.currentPomodoro].maxCounter) * CGFloat(100) }
    
    var width : CGFloat = 88
    var height : CGFloat = 88
    
    var colour: Color {
        switch pomodoroSession.pomodoros[pomodoroSession.currentPomodoro].pomodoroType {
        case .focusSession:
            return Color(Colours.hotCoral)
        case .shortBreak:
            return .green
        case .longBreak:
            return Color(Colours.midnightBlue)
        }
    }
    
    var body: some View {
        let multiplier = width / 44
        let progress = CGFloat(100 - percent) / 100
        
        return ZStack {
            Circle()
                .stroke(Color.black.opacity(0.1), style: StrokeStyle(lineWidth: 5 * multiplier))
                .frame(width: width, height: height)
            Circle()
                .trim(from: progress, to: 1)
                .stroke(LinearGradient(gradient: Gradient(colors: [colour]), startPoint: .topTrailing, endPoint: .bottomLeading), style: StrokeStyle(lineWidth: 5 * multiplier, lineCap: .round))
                .frame(width: width, height: height)
                .rotationEffect(Angle(degrees: 90))
                .rotation3DEffect(Angle(degrees: 180), axis: (x: 1, y: 0, z: 0))
                .shadow(color: colour.opacity(0.3), radius: 3 * multiplier, x: 0, y: 3 * multiplier)
            Text("\((pomodoroSession.pomodoros[pomodoroSession.currentPomodoro].maxCounter - pomodoroSession.pomodoros[pomodoroSession.currentPomodoro].counter).secondsToHoursMinsSecs())").font(Font.system(.body).monospacedDigit())
        }
    }
}

struct RingView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 35) {
            RingView(pomodoroSession: PomodoroSession())
        }
    }
}
