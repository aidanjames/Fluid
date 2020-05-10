//
//  ContentView.swift
//  Fluid
//
//  Created by Aidan Pendlebury on 26/04/2020.
//  Copyright © 2020 Aidan Pendlebury. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var tasks = TasksViewModel()
    
    // Get rid of this when we know what we're doing
    @State private var showingFullScreen = false
    
    var body: some View {
        ZStack {
            
//            Color.black.opacity(0.1).edgesIgnoringSafeArea(.all)
            Color(Colours.midnightBlue).opacity(0.3).edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {

                TimerCardView(tasks: tasks, showingFullScreen: $showingFullScreen)
//                    .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 5)
                    .shadow(color: tasks.isLogging ? Color(Colours.hotCoral).opacity(0.3) : Color.gray.opacity(0.5), radius: 10, x: 0, y: 10)
                
                Spacer()
                
                Text("Recent tasks").font(.title).foregroundColor(Color(Colours.midnightBlue)).bold().padding(.leading).padding(.top)
                
                ScrollView {
                    ForEach(tasks.allTasks) { task in
                        TaskCellView(tasks: self.tasks, task: task)
                            .frame(maxHeight: 400)
                            .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 5)

                    }
                    Spacer()
                }
            }
        }
        .onAppear {
            UIApplication.shared.isIdleTimerDisabled = self.tasks.isLogging
            NotificationManager.shared.requestPermission()
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
