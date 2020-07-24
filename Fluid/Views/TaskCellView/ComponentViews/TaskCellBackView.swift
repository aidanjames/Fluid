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
    
    @State private var showingAlert = false
    @State private var editView = true
    @State private var taskName = ""
    var doneButtonDisabled: Bool { taskName.isEmpty }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    showingAlert.toggle()
                }) {
                    SFSymbols.trashButton.foregroundColor(tasks.currentSelectedTask == nil ? Color(Colours.hotCoral) : .gray).padding(5)
                }
                VStack(spacing: 0) {
                    TextField("", text: $taskName)
                        .foregroundColor(Color(Colours.midnightBlue))
                        .font(.caption)
                        .onAppear {
                            taskName = task.name
                    }
                    Divider()
                }
                .padding(.leading)
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        editView.toggle()
                    }
                } ) {
                    if editView {
                        SFSymbols.chart
                    } else {
                        SFSymbols.list
                    }
                }
                .foregroundColor(Color(Colours.midnightBlue))
                .padding(.horizontal)
                
                
                Button(action: {
                    tasks.changeTask(id: task.id, name: taskName)
                    withAnimation { showingFront.toggle() }
                }) {
                   Text("Done")
                    .foregroundColor(Color(Colours.midnightBlue))
                    .opacity(doneButtonDisabled ? 0.4 : 1)
                }
                .disabled(doneButtonDisabled)
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Delete task?"), message: Text("Are you sure you want to delete this task? This cannot be undone."),
                          primaryButton: .destructive(Text("Delete")) { tasks.delete(task: task) },
                          secondaryButton: .cancel()
                    )
                }
            }
            if task.loggingHistory.isEmpty {
                Text("No logging records")
            } else {
                if editView {
                    LogRecordListView(tasks: tasks, taskID: task.id)
                } else {
                    
                    SingleTaskGraphView(task: task)
                    
                    
                }
            }
            
            
            
        }
        .frame(height: 300)
    }
    
}

struct TaskCellView_Back_Previews: PreviewProvider {
    static var previews: some View {
        TaskCellBackView(tasks: PreviewMockData.tasks, task: PreviewMockData.task, showingFront: .constant(false))
            .padding()
    }
}
