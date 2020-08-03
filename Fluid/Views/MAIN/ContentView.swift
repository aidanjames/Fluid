//
//  ContentView.swift
//  Fluid
//
//  Created by Aidan Pendlebury on 26/04/2020.
//  Copyright © 2020 Aidan Pendlebury. All rights reserved.
//

import AVFoundation
import SwiftUI

struct ContentView: View {
    
    @StateObject var tasks = TasksViewModel()
    
    @State private var hideEverything = false
    @State private var showingFilterField = false
    @State private var searchText = ""
    @State private var taskName = ""
    @State private var isFiltering = false
    @State private var showingSettingsView = false
    
    @Environment(\.colorScheme) var colorScheme
    
    var filteredTasks: [Task] {
        if !searchText.isEmpty {
            return tasks.allTasks.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        } else if !taskName.isEmpty {
            return tasks.allTasks.filter { $0.name.lowercased().contains(taskName.lowercased()) }
        } else {
            return tasks.allTasks
        }
    }
    
    var body: some View {
        
        GeometryReader { bounds in
            
            ZStack {
                
                Color(Colours.midnightBlue).opacity(0.1).edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    
                    HStack {
                        Button(action: { showingSettingsView.toggle() }, label: {
                            Images.cog.renderingMode(.original).padding(.horizontal)
                        })
                        .sheet(isPresented: $showingSettingsView, content: {
                            SettingsView(tasks: tasks)
                        })
                        
                        Spacer()
                    }
                    
                    LazyVStack(spacing: 7) {
                        if !isFiltering{
                            TimerCardView(tasks: tasks, taskName: $taskName)
                                .shadow(color: tasks.isLogging ? Color(Colours.hotCoral).opacity(0.3) : Color(Colours.shadow).opacity(0.5), radius: 10, x: 0, y: 10)
                        }
                        
                        if hideEverything {
                            EmptyView() // Hack to scroll to the top
                        } else if tasks.allTasks.isEmpty {
                            
                            EmptyStateView()
                            
                            Text("Let's get started!")
                                .font(.title)
                                .foregroundColor(Color(Colours.midnightBlue))
                                .bold()
                                .padding(.horizontal, 30)
                                .multilineTextAlignment(.center)
                        } else {
                            
                            if !isFiltering && taskName.isEmpty {
                                HStack {
                                    Text("Recent tasks").font(.title).foregroundColor(Color(Colours.midnightBlue)).bold()
                                    Spacer()
                                }
                                .padding(.horizontal)
                            }
                            if tasks.allTasks.count > 3 && !tasks.isLogging && taskName.isEmpty {
                                FilterView(isFiltering: $isFiltering, searchText: $searchText)
                            }
                            
                            ForEach(filteredTasks) { task in
                                TaskCellView(tasks: tasks, task: task, hideEverything: $hideEverything, isFiltering: $isFiltering, searchText: $searchText, taskName: $taskName)
                                    .frame(maxHeight: 400)
                                    .shadow(color: Color(Colours.shadow).opacity(0.5), radius: 5, x: 0, y: 5)
                            }
                            .animation(.default)
                            
                        }
                        Spacer()
                    }
                    .frame(width: bounds.size.width)
                    .onAppear {
                        UIApplication.shared.isIdleTimerDisabled = tasks.isLogging && tasks.preventScreenLock
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
