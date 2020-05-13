//
//  PopUpView.swift
//  Fluid
//
//  Created by Aidan Pendlebury on 13/05/2020.
//  Copyright © 2020 Aidan Pendlebury. All rights reserved.
//

import SwiftUI

struct PopUpView<Content: View>: View {
    
    @Binding var isShowing: Bool
    
    var content: Content
    
    init(isShowing: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self._isShowing = isShowing
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4).edgesIgnoringSafeArea(.all)
            ZStack {
                
                content
                    .padding(30)
                    .background(Color.white)
                    .cornerRadius(16)
                    
                
            }
            .padding(.horizontal, 20)
        }
    }
}

struct PopUpView_Previews: PreviewProvider {
    @State static var myText = ""
    
    static var previews: some View {
        PopUpView(isShowing: .constant(false)) {
            VStack(alignment: .leading) {
                Text("This is a field")
                TextField("Placeholder", text: $myText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text("This is another field")
                Button("This is a button") {}
            }
        }
    }
}
