//
//  BeerRow.swift
//  CBF
//
//  Created by Adam Reynolds on 21/05/2024.
//

import SwiftUI

struct BeerRow: View {
     @State private var isActive: Bool = false
    
    @Bindable var product: Product
    
    var body: some View {
        // Invisible button to handle row tap
        Button(action: {
            isActive = true // Set the isActive state to trigger the NavigationLink
        }) {
            HStack {
                // Star button
                Button(action: {
                    product.isFavourite.toggle()
                }) {
                    Image(systemName: product.isFavourite ? "star.fill" : "star")
                        .foregroundColor(.yellow) // Customize the star color
                }
                .padding(.trailing, 10) // Adjust the spacing as needed
                
                // Row content
                VStack(alignment: .leading) {
                    HStack {
                        Text(product.name)
                            .font(.headline)
                        Text("(\(product.statusText))")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Text("ABV: \(product.abv)")
                        .font(.subheadline)
                }
                Spacer()
                Toggle("", isOn: $product.isSelected)
                    .labelsHidden()
            }
            .contentShape(Rectangle()) // Define tappable area for the entire row
        }
        .background(
            NavigationLink(
                destination: BeerDetailView(product: product),
                tag: true, // Set a tag to true
                selection: Binding<Bool?>(
                    get: { isActive ? true : nil },
                    set: { newValue in isActive = newValue ?? false }
                )
            ) {
                EmptyView()
            }
            .opacity(0) // Hide the NavigationLink
        )
    }
}
