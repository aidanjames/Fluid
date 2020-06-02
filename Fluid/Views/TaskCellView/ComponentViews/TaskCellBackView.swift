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
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.showingAlert.toggle()
                }) {
                    SFSymbols.trashButton.foregroundColor(tasks.currentSelectedTask == nil ? Color(Colours.hotCoral) : .gray).padding(5)
                }
                
                VStack(spacing: 0) {
                    TextField("", text: $taskName)
                        .font(.caption)
                        .onAppear {
                            self.taskName = self.task.name
                    }
                    Divider()
                }
                .padding(.leading)
                
                
                Spacer()
                
                
                
                Button(action: {
                    withAnimation {
                        self.editView.toggle()
                    }
                } ) {
                    if editView {
                        SFSymbols.chart
                    } else {
                        SFSymbols.list
                    }
                }.padding(.horizontal)
                
                Button("Done") {
                    self.tasks.changeTask(id: self.task.id, name: self.taskName)
                    withAnimation { self.showingFront.toggle() }
                }
                .disabled(self.taskName.isEmpty)
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Delete task?"), message: Text("Are you sure you want to delete this task? This cannot be undone."),
                          primaryButton: .destructive(Text("Delete")) { self.tasks.delete(task: self.task) },
                          secondaryButton: .cancel()
                    )
                }
            }
            if task.loggingHistory.isEmpty {
                Text("No logging records")
            } else {
                if editView {
                    LogRecordListView(tasks: self.tasks, taskID: self.task.id)
                } else {
                    
                    SingleTaskGraphView(task: self.task)
                    
                    
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
