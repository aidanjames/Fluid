//
//  CloseButtonView.swift
//  Fluid
//
//  Created by Aidan Pendlebury on 08/06/2020.
//  Copyright © 2020 Aidan Pendlebury. All rights reserved.
//

import SwiftUI

struct CloseButtonView: View {
    var body: some View {
        SFSymbols.closeCircle
            .font(.title)
            .foregroundColor(Color(Colours.hotCoral))
            .opacity(0.8)
            .padding(.trailing)
            .transition(.move(edge: .trailing))
            .animation(.default)
    }
}

struct CloseButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CloseButtonView()
    }
}
