//
//  BarView.swift
//  Fluid
//
//  Created by Aidan Pendlebury on 21/05/2020.
//  Copyright © 2020 Aidan Pendlebury. All rights reserved.
//

import SwiftUI

struct BarView: View {
    
    var width: CGFloat
    var height: CGFloat
    var taskName: String
    var timeText: String
    
    var body: some View {
        ZStack {
            VStack {
                Text(timeText).font(Font.system(size: width, design: Font.Design.default))
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.green)
                    .frame(width: width * 2, height: height)
            }
            
            Text(taskName).font(Font.system(size: width, design: Font.Design.default))
                .frame(height: height)
                .rotationEffect(.degrees(90))
        }
    }
}

struct BarView_Previews: PreviewProvider {
    static var previews: some View {
        HStack(alignment: .bottom) {
            BarView(width: 10, height: 100, taskName: "Meeting", timeText: "2h 19m")
            BarView(width: 10, height: 200, taskName: "Team meeting at golf club", timeText: "12h 19m")
            BarView(width: 10, height: 30, taskName: "Lunch", timeText: "2h 19m")
        }
    }
}
