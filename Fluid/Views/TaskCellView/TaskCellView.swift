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
        
    var body: some View {
        
        Group {
            if showingFront {
                TaskCellFrontView(task: task, tasks: self.tasks, showingFront: $showingFront)
            } else {
                TaskCellBackView(tasks: tasks, task: task, showingFront: $showingFront)
            }
        }
        .disabled(tasks.currentSelectedTask != nil)
        .opacity(tasks.currentSelectedTask != nil ? 0.3 : 1)
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .padding(.horizontal)
//        .padding(.bottom, showingFront ? 2 : 10)
        
        
    }
    
}

struct TaskCellView_Previews: PreviewProvider {
    static var previews: some View {
        TaskCellView(tasks: PreviewMockData.tasks, task: PreviewMockData.task)
            .frame(height: 150)
            .previewLayout(.sizeThatFits)
    }
}
