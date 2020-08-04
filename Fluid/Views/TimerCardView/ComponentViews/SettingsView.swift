//
//  SettingsView.swift
//  Fluid
//
//  Created by Aidan Pendlebury on 03/08/2020.
//  Copyright © 2020 Aidan Pendlebury. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var tasks: TasksViewModel
    @State private var localPreventScreenLock = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Toggle(isOn: $localPreventScreenLock) {
                    Text("Prevent screen locking when timer running")
                }
            }
            .navigationTitle(Text("Settings"))
            .navigationBarItems(
                leading:
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    },
                trailing:
                    Button("Done") {
                        tasks.preventScreenLock = localPreventScreenLock
                        GeneralSettings.preventScreenLock = localPreventScreenLock
                        UIApplication.shared.isIdleTimerDisabled = tasks.isLogging && tasks.preventScreenLock
                        presentationMode.wrappedValue.dismiss()
                    }
            )
            .onAppear {
                localPreventScreenLock = tasks.preventScreenLock
            }
            
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(tasks: TasksViewModel())
    }
}
