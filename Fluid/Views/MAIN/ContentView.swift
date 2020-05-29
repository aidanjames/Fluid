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
    
    @State private var showingTimerFullScreen = false
    @State private var showingRecentTasksOnly = true
    @State private var hideEverything = false
    
    var filteredTasks: [Task] {
        let arraySlice = tasks.allTasks.prefix(3)
        if showingRecentTasksOnly {
            return Array(arraySlice)
        } else {
            return tasks.allTasks
        }
    }
    
    var body: some View {
        
        GeometryReader { bounds in
            
            ZStack {
                
                Color(Colours.midnightBlue).opacity(0.1).edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    
                    VStack {
                        TimerCardView(tasks: self.tasks, showingFullScreen: self.$showingTimerFullScreen)
                            .shadow(color: self.tasks.isLogging ? Color(Colours.hotCoral).opacity(0.3) : Color.gray.opacity(0.5), radius: 10, x: 0, y: 10)
                        
                        if self.hideEverything {
                            EmptyView() // Hack to scroll to the top
                        } else if self.tasks.allTasks.isEmpty {
                            
                            EmptyStateView()
                            
                            Text("Let's get started!")
                                .font(.title)
                                .foregroundColor(Color(Colours.midnightBlue))
                                .bold()
                                .padding(.horizontal, 30)
                                .multilineTextAlignment(.center)
                        } else {
                            HStack {
                                Text("Recent tasks").font(.title).foregroundColor(Color(Colours.midnightBlue)).bold()
                                Spacer()
                                if self.tasks.allTasks.count > 3 && !self.tasks.isLogging {
                                    Button("Show \(self.showingRecentTasksOnly ? "more" : "less")") {
                                        self.showingRecentTasksOnly.toggle()
                                    }
                                }
                            }
                            .padding(.horizontal)
                            
                            

                                ForEach(self.filteredTasks) { task in
                                    TaskCellView(tasks: self.tasks, task: task, hideEverything: self.$hideEverything)
                                        .frame(maxHeight: 400)
                                        .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 5)
                                }
                            
//                            Button("Hide everything") { self.ScrollToTop() }
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
    
    
    // This is a hack to get scroll view to scroll to the top when logging time for an existing task
//    func ScrollToTop() {
//        self.hideEverything = true
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
//            self.hideEverything = false
//
//        }
//    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
