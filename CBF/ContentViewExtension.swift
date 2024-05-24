//
//  ContentViewExtension.swift
//  CBF
//
//  Created by Adam Reynolds on 21/05/2024.
//

import SwiftUI

extension ContentView {
    var toolbarTitle: some View {
        GeometryReader { geometry in
            VStack {
                Text("Cambridge Beer Festival")
                    .font(.system(size: min(geometry.size.width / 15, 24)))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .frame(height: 44) // Standard height for navigation bar title
    }
}
