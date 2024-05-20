//
//  BeerDetailView.swift
//  CBF
//
//  Created by Adam Reynolds on 20/05/2024.
//

import SwiftUI

struct BeerDetailView: View {
    @Binding var isSelected: Bool
    var producer: Producer
    var product: Product
    
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
            
            Toggle("Tried", isOn: $isSelected)
                .padding(.top, 20)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Beer Details")
    }
}
