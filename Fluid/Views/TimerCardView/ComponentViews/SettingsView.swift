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
    
    var body: some View {
        NavigationView {
            Form {
                Toggle(isOn: $tasks.preventScreenLock) {
                    Text("Prevent screen locking when timer running")
                }
            }
            .navigationTitle(Text("Settings"))
            
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(tasks: TasksViewModel())
    }
}
