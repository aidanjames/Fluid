//
//  ContentView.swift
//  Fluid
//
//  Created by Aidan Pendlebury on 26/04/2020.
//  Copyright © 2020 Aidan Pendlebury. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var tasks = TasksViewModel()
    @State private var showingSessionFinishedPopUp = false
    @State private var showingBreakFinishedPopUp = false

    
    var body: some View {
        ZStack {
            
            Color(Colours.midnightBlue).opacity(0.3).edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {
                TimerCardView(tasks: tasks, showingSessionFinishedPopUp: $showingSessionFinishedPopUp, showingBreakFinishedPopUp: $showingBreakFinishedPopUp)
                    .shadow(color: tasks.isLogging ? Color(Colours.hotCoral).opacity(0.3) : Color.gray.opacity(0.5), radius: 10, x: 0, y: 10)
                
                Spacer()
                
                HStack { // Get rid of this when I've finish testing the popup view
                    Text("Recent tasks").font(.title).foregroundColor(Color(Colours.midnightBlue)).bold().padding(.leading).padding(.top)
//                    Button("Show popup") {
//                        withAnimation {
//                            self.showingPopUpView.toggle()
//                        }
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                            withAnimation {
//                                self.showingPopUpView.toggle()
//                            }
//                        }
//                    }
                }
                
                ScrollView {
                    ForEach(tasks.allTasks) { task in
                        TaskCellView(tasks: self.tasks, task: task)
                            .frame(maxHeight: 400)
                            .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 5)

                    }
                    Spacer()
                }
            }
            .padding(.top)
            
            if showingSessionFinishedPopUp {
                PopUpView(isShowing: $showingSessionFinishedPopUp) {
                    VStack {
                        Text("Session over")
                        Text("Time for a break! 🎉")
                    }

                }
                .transition(.opacity)
            }
            if showingBreakFinishedPopUp {
                PopUpView(isShowing: $showingBreakFinishedPopUp) {
                    VStack {
                        Text("Break over")
                        Text("Time to get back to work! 👨🏽‍💻")
                    }

                }
                .transition(.opacity)
            }
        }
           
        .onAppear {
            UIApplication.shared.isIdleTimerDisabled = self.tasks.isLogging
            NotificationManager.shared.requestPermission()
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
