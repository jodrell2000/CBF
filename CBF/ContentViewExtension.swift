//
//  ContentViewExtension.swift
//  CBF
//
//  Created by Adam Reynolds on 21/05/2024.
//

import SwiftUI

extension ContentView {
    func navigationLink(for product: Product, in producer: Producer) -> some View {
        NavigationLink(destination: BeerDetailView(
            isSelected: Binding(
                get: { dataManager.selectedProducts[product.id, default: false] },
                set: {
                    dataManager.selectedProducts[product.id] = $0
                    dataManager.saveSelectedProducts()
                }
            ),
            isFavourite: Binding(
                get: { UserDefaults.standard.bool(forKey: "favourite_\(product.id)") },
                set: { UserDefaults.standard.set($0, forKey: "favourite_\(product.id)") }
            ),
            producer: producer,
            product: product
        )) {
            BeerRow(
                isSelected: Binding(
                    get: { dataManager.selectedProducts[product.id, default: false] },
                    set: {
                        dataManager.selectedProducts[product.id] = $0
                        dataManager.saveSelectedProducts()
                    }
                ),
                product: product,
                producer: producer
            )
        }
    }
    
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

