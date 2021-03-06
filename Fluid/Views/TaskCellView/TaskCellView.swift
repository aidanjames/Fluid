//
//  TaskCellView.swift
//  Fluid
//
//  Created by Aidan Pendlebury on 29/04/2020.
//  Copyright © 2020 Aidan Pendlebury. All rights reserved.
//

import SwiftUI

struct TaskCellView: View {
    
    @ObservedObject var tasks: TasksViewModel
    var task: Task
    
    @State private var showingFront = true
    @Binding var hideEverything: Bool
    @Binding var isFiltering: Bool
    @Binding var searchText: String
    @Binding var taskName: String
    
    @Environment(\.colorScheme) var colorScheme
        
    var body: some View {
        
        Group {
            if showingFront {
                TaskCellFrontView(task: task, tasks: tasks, showingFront: $showingFront, hideEverything: $hideEverything, isFiltering: $isFiltering, searchText: $searchText, taskName: $taskName)
            } else {
                TaskCellBackView(tasks: tasks, task: task, showingFront: $showingFront)
            }
        }
                    
        .disabled(tasks.currentSelectedTask != nil)
        .opacity(tasks.currentSelectedTask != nil ? 0.3 : 1)
        .padding()
        .background(Color(Colours.cardViewColour))
        .cornerRadius(16)
        .padding(.horizontal)

    }
    
}

struct TaskCellView_Previews: PreviewProvider {
    static var previews: some View {
        TaskCellView(tasks: PreviewMockData.tasks, task: PreviewMockData.task, hideEverything: .constant(false), isFiltering: .constant(false), searchText: .constant(""), taskName: .constant(""))
            .frame(height: 150)
            .previewLayout(.sizeThatFits)
    }
}
