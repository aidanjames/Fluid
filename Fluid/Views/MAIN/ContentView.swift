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
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.1).edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading) {
//                PomodoroView()
                TimerCardView(tasks: tasks)
                    .padding(.bottom)
                    .edgesIgnoringSafeArea(.top)
//                    .shadow(radius: 5, x: 5, y: 5)
//                    .shadow(color: .gray, radius: 2, x: 2, y: 2)
                Spacer()
                Text("Continue an existing task").font(.body).bold().padding(.leading)
                ScrollView {
                    ForEach(tasks.allTasks) { task in
                        TaskCellView(tasks: self.tasks, task: task)
                            .frame(maxHeight: 400)
//                            .shadow(radius: 5, x: 5, y: 5)
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
