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
    var allTasks: TasksViewModel
    @Binding var currentSelectedTask: Task?
    @Binding var showingFront: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(task.name).font(.body).bold().padding(.bottom, 5)
                Text("Today: \(task.totalTimeInSeconds.secondsToHoursMins())").foregroundColor(.secondary)
                Text("This weeek: \(task.totalTimeInSeconds.secondsToHoursMins())").foregroundColor(.secondary)
                Text("All time: \(task.totalTimeInSeconds.secondsToHoursMins())").foregroundColor(.secondary)
            }.font(.footnote)
            
            
            Spacer()
            Button(action: {
                withAnimation { self.showingFront.toggle() }
            }) {
                Image(systemName: SFSymbols.moreButton).foregroundColor(currentSelectedTask == nil ? .blue : .gray).font(.largeTitle).padding(5)
            }
            Button(action: {
                self.currentSelectedTask = self.task
                if let index = self.allTasks.allTasks.firstIndex(where: { $0.id == self.task.id }) {
                    withAnimation { self.allTasks.allTasks.move(from: index, to: 0) }
                }
            }) {
                Image(systemName: SFSymbols.playButton).foregroundColor(currentSelectedTask == nil ? .green : .gray).font(.largeTitle).padding(5)
            }
        }
    }
}

struct TaskCellView_Front_Previews: PreviewProvider {
    static var previews: some View {
        TaskCellFrontView(task: PreviewMockData.task, allTasks: PreviewMockData.tasks, currentSelectedTask: .constant(nil), showingFront: .constant(true))
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
