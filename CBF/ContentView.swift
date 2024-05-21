//
//  ContentView.swift
//  CBF
//
//  Created by Adam Reynolds on 20/05/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var dataManager = DataManager() // Changed to internal access level
    
    var body: some View {
        NavigationView {
            List {
                ForEach(dataManager.producers) { producer in
                    Section(header: Text(producer.name).font(.headline)) {
                        ForEach(producer.products) { product in
                            navigationLink(for: product, in: producer)
                        }
                    }
                }
            }
            .toolbar {
            ToolbarItem(placement: .principal) {
                    toolbarTitle
                }
            }
        .onAppear {
                dataManager.fetchData()
                dataManager.loadSelectedProducts()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
