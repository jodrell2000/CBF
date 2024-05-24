//
//  BeerDetailView.swift
//  CBF
//
//  Created by Adam Reynolds on 20/05/2024.
//

import SwiftUI

struct BeerDetailView: View {
    @Bindable var product: Product

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(product.producer?.name ?? "Producer")
                .font(.largeTitle)
                .padding(.bottom, 10)
            
            if let yearFounded = product.producer?.yearFounded {
                Text("Year Founded: \(yearFounded)")
            }
            
            if let notes = product.producer?.notes {
                Text("Notes: \(notes)")
            }
            
            if let location = product.producer?.location {
                Text("Location: \(location)")
            }
            
            Divider().padding(.vertical, 10)
            
            Text(product.name)
                .font(.title)
                .padding(.bottom, 5)
            
            if let style = product.style {
                Text("Style: \(style)")
            }
            
            Text("ABV: \(product.abv)")
            
            if let dispense = product.dispense {
                Text("Dispense: \(dispense)")
            }
            
            if let notes = product.notes {
                Text("Notes: \(notes)")
            }
            
            if let allergens = product.allergens {
                if !allergens.allergenNames.isEmpty {
                    Text("Allergens: \(allergens.allergenNames.joined(separator: ", "))")
                } else {
                    Text("Allergens: None")
                }
            } else {
                Text("Allergens: None")
            }
            
            Text("Status: \(product.statusText)")
            
            Spacer()
            
            HStack {
                Text("Favourite")
                    .font(.headline)
                    .fontWeight(.regular)
                    .foregroundColor(.primary)
                    .padding(.trailing, 10)

                Spacer()
                Button(action: {
                    product.isFavourite.toggle()
                }) {
                    Image(systemName: product.isFavourite ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                }
            }
            
            Toggle("Tried", isOn: $product.isSelected)
                .padding(.top, 20)
            
            Spacer()
       }
        .padding()
        .navigationTitle("Beer Details")
    }
}
