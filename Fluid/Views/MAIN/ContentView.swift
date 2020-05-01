//
//  ContentView.swift
//  Fluid
//
//  Created by Aidan Pendlebury on 26/04/2020.
//  Copyright © 2020 Aidan Pendlebury. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var tasks = Tasks()
    @State private var currentSelectedTask: Task?
    
    
    var body: some View {
        ZStack {
            Color.blue.opacity(0.2).edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Image(systemName: SFSymbols.hamburgerMenu).font(.title).foregroundColor(.blue).padding(.horizontal)
                    Spacer()
                }
                TimerCardView(tasks: tasks, currentSelectedTask: $currentSelectedTask)
                    .padding()
                    .shadow(radius: 5, x: 5, y: 5)
                Spacer()
                Text("Recent tasks")
                ScrollView {
                    ForEach(tasks.allTasks) { task in
                        TaskCellView(allTasks: self.tasks, task: task, currentSelectedTask: self.$currentSelectedTask)
                        .shadow(radius: 5, x: 5, y: 5)
                    }
                    Spacer()
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
