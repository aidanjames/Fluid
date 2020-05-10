//
//  TimerContainerView.swift
//  Fluid
//
//  Created by Aidan Pendlebury on 10/05/2020.
//  Copyright © 2020 Aidan Pendlebury. All rights reserved.
//

import SwiftUI

struct TimerContainerView: View {
    
    @ObservedObject var tasks: TasksViewModel
    
    @State private var showingFullScreen = false
    
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4).edgesIgnoringSafeArea(.all)
            TimerCardView(tasks: self.tasks, showingFullScreen: $showingFullScreen)
            
        }
    }
}

struct TimerContainerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerContainerView(tasks: TasksViewModel())
    }
}
