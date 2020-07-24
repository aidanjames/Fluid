//
//  TaskCellView-Front.swift
//  Fluid
//
//  Created by Aidan Pendlebury on 30/04/2020.
//  Copyright © 2020 Aidan Pendlebury. All rights reserved.
//

import SwiftUI

struct TaskCellFrontView: View {
    
    var task: Task
    @ObservedObject var tasks: TasksViewModel
    @Binding var showingFront: Bool
    @Binding var hideEverything: Bool
    @Binding var isFiltering: Bool
    @Binding var searchText: String
    @Binding var taskName: String
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(task.name).font(.body).bold().foregroundColor(Color(Colours.midnightBlue)).padding(.bottom, 5)
                Text("Today: \(task.getSecondsRecordedToday().secondsToHoursMins())")
                Text("This week: \(task.getSecondsRecordedThisWeek().secondsToHoursMins())")
                Text("This month: \(task.getSecondsRecordedThisMonth().secondsToHoursMins())")
                Text("All time: \(task.getSecondsRecordedAllTime().secondsToHoursMins())")
            }
            .foregroundColor(colorScheme == .dark ? Color(Colours.midnightBlue) : .gray)
            .font(.footnote)
            
            Spacer()
            
            Button(action: {
                withAnimation { showingFront.toggle() }
            }) {
                SFSymbols.moreButtonWithoutCircle
                    .foregroundColor(tasks.currentSelectedTask == nil ? Color(Colours.midnightBlue) : .gray)
                    .font(.largeTitle).padding(5)
            }
            
            Button(action: {
                ScrollToTop()
            }) {
                SFSymbols.playButton.foregroundColor(tasks.currentSelectedTask == nil ? Color(Colours.midnightBlue) : .gray).font(.largeTitle).padding(5)
            }
        }
        .blur(radius: tasks.isLogging ? 0.2 : 0)
    }
    
    // This is a hack to get scroll view to scroll to the top when logging time for an existing task
    func ScrollToTop() {
        hideEverything = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            hideEverything = false
            isFiltering = false
            searchText = ""
            taskName = ""
            if let index = tasks.allTasks.firstIndex(where: { $0.id == task.id }) {
                withAnimation { tasks.allTasks.move(from: index, to: 0) }
            }
            tasks.currentSelectedTask = task
            tasks.isLogging = true
            tasks.startLoggingForCurrentTask()
        }
    }
}

struct TaskCellView_Front_Previews: PreviewProvider {
    static var previews: some View {
        TaskCellFrontView(task: PreviewMockData.task, tasks: PreviewMockData.tasks, showingFront: .constant(true), hideEverything: .constant(false), isFiltering: .constant(false), searchText: .constant(""), taskName: .constant(""))
            .previewLayout(.sizeThatFits)
    }
}
