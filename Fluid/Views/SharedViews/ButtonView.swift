//
//  ButtonView.swift
//  Fluid
//
//  Created by Aidan Pendlebury on 08/05/2020.
//  Copyright © 2020 Aidan Pendlebury. All rights reserved.
//

import SwiftUI

struct ButtonView: View {
    
    var buttonText: String
    var backgroundColour: Color
    var maxWitdh: CGFloat = .infinity
    
    var body: some View {
        HStack {
            Spacer()
            Text(buttonText)
                .foregroundColor(.white)
                .font(.caption)
                .bold()
            Spacer()
        }
        .padding(.horizontal, 5)
        .padding(.vertical, 12)
        .background(backgroundColour)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .frame(maxWidth: maxWitdh)
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(buttonText: "Start", backgroundColour: Color(Colours.hotCoral))
    }
}
