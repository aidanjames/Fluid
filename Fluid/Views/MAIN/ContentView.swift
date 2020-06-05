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
    @State private var showingFilterField = false
    @State private var searchText = ""
    @State private var isFiltering = false
    
    @Environment(\.colorScheme) var colorScheme
    
    var filteredTasks: [Task] {
        let arraySlice = tasks.allTasks.prefix(3)
        if !searchText.isEmpty {
            return tasks.allTasks.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }  else if showingRecentTasksOnly {
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
                        if !self.isFiltering{
                            TimerCardView(tasks: self.tasks, showingFullScreen: self.$showingTimerFullScreen)
                                .shadow(color: self.tasks.isLogging ? Color(Colours.hotCoral).opacity(0.3) : Color(Colours.shadow).opacity(0.5), radius: 10, x: 0, y: 10)
                            
                        }
                        
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
                            
                            if !self.isFiltering {
                                HStack {
                                    Text("Recent tasks").font(.title).foregroundColor(Color(Colours.midnightBlue)).bold()
                                    Spacer()
                                    if self.tasks.allTasks.count > 3 && !self.tasks.isLogging && self.searchText.isEmpty {
                                        Button(action: { self.showingRecentTasksOnly.toggle() }) {
                                            Text("Show \(self.showingRecentTasksOnly ? "more" : "less")")
                                                .font(.caption)
                                                .foregroundColor(self.colorScheme == .dark ? .black : .white)
                                                .padding(.horizontal)
                                                .padding(.vertical, 3)
                                                .background(Color(Colours.midnightBlue))
                                                .cornerRadius(16)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }

                            
                            if self.tasks.allTasks.count > 3 && !self.tasks.isLogging {
                                FilterView(isFiltering: self.$isFiltering, searchText: self.$searchText, showingRecentTasksOnly: self.$showingRecentTasksOnly)

                            }
                            
                            ForEach(self.filteredTasks) { task in
                                TaskCellView(tasks: self.tasks, task: task, hideEverything: self.$hideEverything, isFiltering: self.$isFiltering, searchText: self.$searchText)
                                    .frame(maxHeight: 400)
                                    .shadow(color: Color(Colours.shadow).opacity(0.5), radius: 5, x: 0, y: 5)
                            }
                            .animation(.default)
                            
                        }
                        Spacer()
                    }
                    .frame(width: bounds.size.width)
                    .onAppear {
                        UIApplication.shared.isIdleTimerDisabled = self.tasks.isLogging
                        NotificationManager.shared.requestPermission()
                        NotificationManager.shared.cancelAllNotificaitons()
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
