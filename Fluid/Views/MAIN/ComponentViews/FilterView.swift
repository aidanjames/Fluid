//
//  FilterView.swift
//  Fluid
//
//  Created by Aidan Pendlebury on 03/06/2020.
//  Copyright © 2020 Aidan Pendlebury. All rights reserved.
//

import SwiftUI

struct FilterView: View {
    
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            ZStack {
                Color(Colours.cardViewColour)
                    .frame(height: 35)
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(Color(Colours.midnightBlue).opacity(0.5)))
                HStack {
                    SFSymbols.magnifyingGlass.foregroundColor(Color(Colours.midnightBlue).opacity(0.5)).padding(.leading)
                    TextField("Search", text: self.$searchText)
                }
            }
            .animation(.default)
            .padding(.leading)
            .padding(.trailing, searchText.isEmpty ? 16 : 0)
            
            if !searchText.isEmpty {
                Button(action: {
                    self.searchText = ""
                    UIApplication.shared.endEditing()
                } ) {
                    SFSymbols.closeCircle
                        .font(.title)
                        .foregroundColor(Color(Colours.hotCoral))
                        .opacity(0.8)
                        .padding(.trailing)
                        .transition(.move(edge: .trailing))
                        .animation(.default)
                }
            }
        }
        .padding(.bottom, 10)
        
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(searchText: .constant("fef"))
    }
}
