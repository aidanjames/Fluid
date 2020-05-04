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
            Color.blue.opacity(0.2).edgesIgnoringSafeArea(.all)
            VStack {
                TimerCardView(tasks: tasks)
                    .padding()
                    .shadow(radius: 5, x: 5, y: 5)
                Spacer()
                Text("Recent tasks")
                ScrollView {
                    ForEach(tasks.allTasks) { task in
                        TaskCellView(tasks: self.tasks, task: task)
                            .frame(maxHeight: 400)
                            .shadow(radius: 5, x: 5, y: 5)
                    }
                    Spacer()
                }
            }
        }
        .onAppear { UIApplication.shared.isIdleTimerDisabled = MyTimer.shared.isCounting }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
