//
//  TaskCellView.swift
//  Fluid
//
//  Created by Aidan Pendlebury on 29/04/2020.
//  Copyright © 2020 Aidan Pendlebury. All rights reserved.
//

import SwiftUI

struct TaskCellView: View {
    
    var allTasks: Tasks
    var task: Task
    @Binding var currentSelectedTask: Task?
    
    @State private var showingFront = true
        
    var body: some View {
        
        Group {
            if showingFront {
                TaskCellFrontView(task: task, allTasks: self.allTasks, currentSelectedTask: $currentSelectedTask, showingFront: $showingFront)
            } else {
                TaskCellBackView(task: task, allTasks: allTasks, currentSelectedTask: $currentSelectedTask, showingFront: $showingFront)
            }
        }
        .disabled(currentSelectedTask != nil)
        .opacity(currentSelectedTask != nil ? 0.3 : 1)
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .padding(.horizontal)
        
        
    }
    
}

struct TaskCellView_Previews: PreviewProvider {
    static var previews: some View {
        TaskCellView(allTasks: PreviewMockData.tasks, task: PreviewMockData.task, currentSelectedTask: .constant(nil))
            .frame(height: 150)
            .previewLayout(.sizeThatFits)
    }
}
