//
//  WelcomeView.swift
//  Fluid
//
//  Created by Aidan Pendlebury on 27/04/2020.
//  Copyright © 2020 Aidan Pendlebury. All rights reserved.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.green.opacity(0.2).edgesIgnoringSafeArea(.all)
                VStack {
                    Image("Tasks")
                        .resizable()
                        .scaledToFit()
                    Text("Welcome to fluid.").font(.largeTitle)
                    Button("Continue") { }.padding()
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
