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
    @Binding var showingRecentTasksOnly: Bool
    
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
            
            if self.isFiltering {
                Button(action: {
                    self.isFiltering = false
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
            
        .onTapGesture {
            self.isFiltering = true
            self.showingRecentTasksOnly = false
        }
        .padding(.bottom, 10)
        .padding(.top, self.isFiltering ? 10 : 0)
        
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(isFiltering: .constant(false), searchText: .constant("fef"), showingRecentTasksOnly: .constant(false))
    }
}
