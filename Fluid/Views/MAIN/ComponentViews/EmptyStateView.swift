//
//  EmptyStateView.swift
//  Fluid
//
//  Created by Aidan Pendlebury on 28/05/2020.
//  Copyright © 2020 Aidan Pendlebury. All rights reserved.
//

import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        Images.emptyState
        .resizable()
        .scaledToFit()
    }
}

struct EmptyStateView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyStateView()
    }
}
