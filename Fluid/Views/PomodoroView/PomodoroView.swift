//
//  PomodoroView.swift
//  Fluid
//
//  Created by Aidan Pendlebury on 07/05/2020.
//  Copyright © 2020 Aidan Pendlebury. All rights reserved.
//

import SwiftUI

struct PomodoroView: View {
    
    /*
     Configuration items:
     - Auto rollover - i.e. do not require user interaction (default = false)
     - Session length (default = 25 min)
     - Short Break length (default = 5 min)
     - Long break length (default = 20 min)
     - Number of sessions between long breaks (default = 4)
     */
    @ObservedObject var pomodoroSession = PomodoroViewModel()
    @State private var counter: Int = 1500

    
    var body: some View {
        VStack {
            Button("Let it happen") {
                
            }
            Text("\(counter)").padding()
        }
    }
    

}

struct PomodoroView_Previews: PreviewProvider {
    static var previews: some View {
        PomodoroView()
    }
}
