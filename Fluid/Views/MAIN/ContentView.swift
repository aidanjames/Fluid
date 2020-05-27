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
    
    @State var showingTimerFullScreen = false
    
    var body: some View {
        
        GeometryReader { bounds in
            
            ZStack {
                
                Color(Colours.midnightBlue).opacity(0.1).edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    
                    VStack {
                        TimerCardView(tasks: self.tasks, showingFullScreen: self.$showingTimerFullScreen)
                            .shadow(color: self.tasks.isLogging ? Color(Colours.hotCoral).opacity(0.3) : Color.gray.opacity(0.5), radius: 10, x: 0, y: 10)
                        
                        
                        // TODO: Add empty state view
                        
                        Text("Recent tasks").font(.title).foregroundColor(Color(Colours.midnightBlue)).bold()
                        
                        ForEach(self.tasks.allTasks) { task in
                            TaskCellView(tasks: self.tasks, task: task)
                                .frame(maxHeight: 400)
                                .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 5)
                            
                        }
                        Spacer()
                        
                    }
                    .frame(width: bounds.size.width)
                        
                    .onAppear {
                        UIApplication.shared.isIdleTimerDisabled = self.tasks.isLogging
                        NotificationManager.shared.requestPermission()
                    }
                }
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
