//
//  BeerDetailView.swift
//  CBF
//
//  Created by Adam Reynolds on 20/05/2024.
//

import SwiftUI

import SwiftUI

struct BeerDetailView: View {
    @Binding var isSelected: Bool
    @Binding var isFavourite: Bool
    var producer: Producer
    var product: Product
    
    init(isSelected: Binding<Bool>, isFavourite: Binding<Bool>, producer: Producer, product: Product) {
        self._isSelected = isSelected
        self._isFavourite = isFavourite
        self.producer = producer
        self.product = product
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(producer.name)
                .font(.largeTitle)
                .padding(.bottom, 10)
            
            if let yearFounded = producer.year_founded {
                Text("Year Founded: \(yearFounded)")
            }
            if let notes = producer.notes {
                Text("Notes: \(notes)")
            }
            if let location = producer.location {
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
            if !product.allergens.allergenNames.isEmpty {
                Text("Allergens: \(product.allergens.allergenNames.joined(separator: ", "))")
            } else {
                Text("Allergens: None")
            }
            Text("Status: \(product.status_text)")
            
            Spacer()
            
            HStack {
                Text("Favourite")
                    .font(.headline)
                    .fontWeight(.regular)
                    .foregroundColor(.primary)
                    .padding(.trailing, 10)

                Spacer()
                Button(action: {
                    isFavourite.toggle()
                    UserDefaults.standard.set(isFavourite, forKey: "favourite_\(product.id)")
                    // Explicitly update the binding value to force UI refresh
                    isFavourite = UserDefaults.standard.bool(forKey: "favourite_\(product.id)")
                    print("isFavourite toggled:", isFavourite)
                }) {
                    Image(systemName: isFavourite ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                }
            }
            
            Toggle("Tried", isOn: $isSelected)
                .padding(.top, 20)
            
            Spacer()
       }
        .padding()
        .navigationTitle("Beer Details")
        .onAppear {
            // Load the initial state from UserDefaults
            isFavourite = UserDefaults.standard.bool(forKey: "favourite_\(product.id)")
        }
    }
}
