//
//  ProgressDotView.swift
//  Fluid
//
//  Created by Aidan Pendlebury on 12/05/2020.
//  Copyright © 2020 Aidan Pendlebury. All rights reserved.
//

import SwiftUI

struct ProgressDotView: View {
    @ObservedObject var pomodoroSession: PomodoroSession

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                ForEach(self.pomodoroSession.pomodoros) { pomodoro in
                    DotView(pomodoroType: pomodoro.pomodoroType, pomodoroState: pomodoro.state)
                        .padding(3)
                        .frame(width: geometry.size.width / CGFloat(self.pomodoroSession.pomodoros.count), height: geometry.size.width / CGFloat(self.pomodoroSession.pomodoros.count))
                }
            }
            
        }
    }
    
}


struct DotView: View {
    var pomodoroType: PomodoroType
    var pomodoroState: PomodoroState
    
    var body: some View {
        if pomodoroState == .active {
            return Circle()
                .fill(colourForPomodoroType())
                .frame(maxWidth: 30)
                .eraseToAnyView()
        } else if pomodoroState == .done {
            return Circle()
                .fill(colourForPomodoroType())
                .opacity(0.3)
                .frame(maxWidth: 30)

                .eraseToAnyView()
        } else {
            return Circle()
                .stroke(colourForPomodoroType())
                .opacity(0.3)
                .frame(maxWidth: 30)

                .eraseToAnyView()
        }
    }
    
    
    func colourForPomodoroType() -> Color {
        switch pomodoroType {
        case .focusSession:
            return Color(Colours.hotCoral)
        case .shortBreak:
            return Color.green
        case .longBreak:
            return Color.blue
        }
    }
}





struct ProgressDotView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressDotView(pomodoroSession: PomodoroSession())
    }
}
