//
//  BeerRow.swift
//  CBF
//
//  Created by Adam Reynolds on 21/05/2024.
//

import SwiftUI

struct BeerRow: View {
    @Binding var isSelected: Bool
    var product: Product
    var producer: Producer
    @State private var isActive: Bool = false
    @State private var isFavourite: Bool
    
    init(isSelected: Binding<Bool>, product: Product, producer: Producer) {
        self._isSelected = isSelected
        self.product = product
        self.producer = producer
        // Initialize isFavourite based on UserDefaults
        _isFavourite = State(initialValue: UserDefaults.standard.bool(forKey: "favourite_\(product.id)"))
    }

    var body: some View {
        // Invisible button to handle row tap
        Button(action: {
            isActive = true // Set the isActive state to trigger the NavigationLink
        }) {
            HStack {
                // Star button
                Button(action: {
                    // Handle favourite logic here
                    isFavourite.toggle()
                    print("isFavourite toggled:", isFavourite)
                    UserDefaults.standard.set(isFavourite, forKey: "favourite_\(product.id)")
                }) {
                    Image(systemName: isFavourite ? "star.fill" : "star")
                        .foregroundColor(.yellow) // Customize the star color
                }
                .padding(.trailing, 10) // Adjust the spacing as needed
                
                // Row content
                VStack(alignment: .leading) {
                    HStack {
                        Text(product.name)
                            .font(.headline)
                        Text("(\(product.status_text))")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Text("ABV: \(product.abv)")
                        .font(.subheadline)
                }
                Spacer()
                Toggle("", isOn: $isSelected)
                    .labelsHidden()
            }
            .contentShape(Rectangle()) // Define tappable area for the entire row
        }
        .background(
            NavigationLink(
                destination: BeerDetailView(
                    isSelected: $isSelected,
                    isFavourite: $isFavourite,
                    producer: producer,
                    product: product
                ),
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
