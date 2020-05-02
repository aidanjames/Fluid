//
//  TaskCellView-Back.swift
//  Fluid
//
//  Created by Aidan Pendlebury on 30/04/2020.
//  Copyright © 2020 Aidan Pendlebury. All rights reserved.
//

import SwiftUI

struct TaskCellBackView: View {
    
    var task: Task
    var allTasks: TasksViewModel
    @Binding var currentSelectedTask: Task?
    @Binding var showingFront: Bool
    
    
    var body: some View {
        HStack {
            Button(action: {
                self.delete()
            }) {
                Image(systemName: SFSymbols.trashButton).foregroundColor(currentSelectedTask == nil ? .red : .gray).font(.largeTitle).padding(5)
            }
            Spacer()
            Button("Done") {
                withAnimation { self.showingFront.toggle() }
            }
        }
    }
    
    func delete() {
        if let index = allTasks.allTasks.firstIndex(where: { $0.id == self.task.id }) {
            self.allTasks.allTasks.remove(at: index)
            FileManager.default.writeData(self.allTasks.allTasks, to: FMKeys.allTasks)
        }
    }
}

struct TaskCellView_Back_Previews: PreviewProvider {
    static var previews: some View {
        TaskCellBackView(task: PreviewMockData.task, allTasks: PreviewMockData.tasks, currentSelectedTask: .constant(nil), showingFront: .constant(false))
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
