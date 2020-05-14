//
//  PomodoroSettingsView.swift
//  Fluid
//
//  Created by Aidan Pendlebury on 14/05/2020.
//  Copyright © 2020 Aidan Pendlebury. All rights reserved.
//

import SwiftUI

struct PomodoroSettingsView: View {
    
    @ObservedObject var pomodoroSession: PomodoroSession
    @Environment(\.presentationMode) var presentationMode
    
    @State private var sessionLength = ""
    @State private var shortBreakLength = ""
    @State private var longBreakLength = ""
    @State private var numberOfSessionsPerRound = ""
    
    var saveButtonDisabled: Bool {
        
        if let sessionLengthInt = Int(sessionLength), let shortBreakLengthInt = Int(shortBreakLength), let longBreakLengthInt = Int(longBreakLength), let numberOfSessionPerRoundInt = Int(numberOfSessionsPerRound) {
            
            if sessionLengthInt > 0 && sessionLengthInt <= 60 && shortBreakLengthInt > 0 && shortBreakLengthInt <= 60 && longBreakLengthInt > 0 && longBreakLengthInt <= 60 && numberOfSessionPerRoundInt > 0 && numberOfSessionPerRoundInt <= 10 {
                return false
            }
        }
        
        
        return true
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Session Length (mins) - max 60")) {
                    TextField("Length in mins", text: $sessionLength)
                }
                Section(header: Text("Short break Length (mins) - max 60")) {
                    TextField("Length in mins", text: $shortBreakLength)
                }
                Section(header: Text("Long break Length (mins) - max 60")) {
                    TextField("Length in mins", text: $longBreakLength)
                }
                Section(header: Text("Number of sessions before long break - max 10")) {
                    TextField("Number of rounds", text: $numberOfSessionsPerRound)
                }
                Button(action: self.restoreDefaultSettings) {
                    HStack {
                        Spacer()
                        Text("Reset to default settings")
                            .foregroundColor(.red)
                        Spacer()
                    }
                }
            }
            .keyboardType(.numberPad)
            .navigationBarTitle("Pomodoro settings")
            .navigationBarItems(
                leading:
                Button("Cancel") { self.presentationMode.wrappedValue.dismiss() },
                trailing:
                Button("Save") { self.saveSettings() }.disabled(saveButtonDisabled)
            )
                .onAppear(perform: loadExistingSettings)
        }
    }
    
    func loadExistingSettings() {
        self.sessionLength = "\(PomodoroSettings.sessionLength / 60)"
        self.shortBreakLength = "\(PomodoroSettings.shortBreakLength / 60)"
        self.longBreakLength = "\(PomodoroSettings.longBreakLength / 60)"
        self.numberOfSessionsPerRound = "\(PomodoroSettings.numberOfSessionsBeforeLongBreak)"
    }
    
    func saveSettings() {
        PomodoroSettings.sessionLength = (Int(self.sessionLength) ?? 25) * 60
        PomodoroSettings.shortBreakLength = (Int(self.shortBreakLength) ?? 5) * 60
        PomodoroSettings.longBreakLength = (Int(self.longBreakLength) ?? 20) * 60
        PomodoroSettings.numberOfSessionsBeforeLongBreak = Int(self.numberOfSessionsPerRound) ?? 4
        pomodoroSession.resetPomodoroSession()
        self.presentationMode.wrappedValue.dismiss()
    }

    func restoreDefaultSettings() {
        PomodoroSettings.sessionLength = 25 * 60
        PomodoroSettings.shortBreakLength = 5 * 60
        PomodoroSettings.longBreakLength = 20 * 60
        PomodoroSettings.numberOfSessionsBeforeLongBreak = 4
        
        self.sessionLength = "25"
        self.shortBreakLength = "5"
        self.longBreakLength = "20"
        self.numberOfSessionsPerRound = "4"
        
        pomodoroSession.resetPomodoroSession()
    }
}

struct PomodoroSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        PomodoroSettingsView(pomodoroSession: PomodoroSession())
    }
}
