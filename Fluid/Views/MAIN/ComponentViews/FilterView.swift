//
//  FilterView.swift
//  Fluid
//
//  Created by Aidan Pendlebury on 03/06/2020.
//  Copyright © 2020 Aidan Pendlebury. All rights reserved.
//

import SwiftUI

struct FilterView: View {
    
    @Binding var isFiltering: Bool
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
                    TextField("Search", text: $searchText)
                }
            }
            .animation(.default)
            .padding(.leading)
            .padding(.trailing, searchText.isEmpty ? 16 : 0)
            
            if isFiltering {
                Button(action: {
                    isFiltering = false
                    searchText = ""
                    UIApplication.shared.endEditing()
                } ) {
                    CloseButtonView()
                }
            }
        }
            
        .onTapGesture {
            isFiltering = true
        }
        .padding(.bottom, 10)
        .padding(.top, isFiltering ? 10 : 0)
        
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(isFiltering: .constant(false), searchText: .constant("fef"))
    }
}
