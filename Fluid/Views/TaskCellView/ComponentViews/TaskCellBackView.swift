//
//  TaskCellView-Back.swift
//  Fluid
//
//  Created by Aidan Pendlebury on 30/04/2020.
//  Copyright © 2020 Aidan Pendlebury. All rights reserved.
//

import SwiftUI

struct TaskCellBackView: View {
    
    @ObservedObject var tasks: TasksViewModel
    var task: Task
    
    @Binding var showingFront: Bool
    
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.tasks.delete(task: self.task)
                }) {
                    SFSymbols.trashButton.foregroundColor(tasks.currentSelectedTask == nil ? .red : .gray).padding(5)
                }
                Spacer()
                Button("Done") {
                    withAnimation { self.showingFront.toggle() }
                }
            }
            if task.loggingHistory.isEmpty {
                Text("No logging records")
            } else {
                LogRecordListView(tasks: self.tasks, taskID: self.task.id)
            }
            
        }
    }
    
}

struct TaskCellView_Back_Previews: PreviewProvider {
    static var previews: some View {
        TaskCellBackView(tasks: PreviewMockData.tasks, task: PreviewMockData.task, showingFront: .constant(false))
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
