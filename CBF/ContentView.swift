//
//  ContentView.swift
//  CBF
//
//  Created by Adam Reynolds on 20/05/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    
    @Query(sort: \Producer.name, order: .forward) var producers: [Producer]
    
    @State private var sectionStates: [String: Bool] = [:]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(groupedProducts.keys.sorted(), id: \.self) { bar in
                    Section(header: SectionHeaderView(title: bar, isExpanded: sectionStates[bar] ?? false)
                        .onTapGesture {
                            toggleSection(for: bar)
                        }) {
                        if sectionStates[bar] ?? false {
                            if let producersForBar = groupedProducts[bar], sectionStates[bar] ?? false {
                                ForEach(producersForBar.keys.sorted(), id: \.self) { producerName in
                                    Section(header: Text(producerName)) {
                                        if let products = groupedProducts[bar]?[producerName] {
                                            ForEach(products, id: \.self) { product in
                                                NavigationLink(destination: BeerDetailView(product: product)) {
                                                    BeerRow(product: product)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    toolbarTitle
                }
            }
        }
        .task {
            await NetworkManager.fetchData(into: context)
            updateSectionStates()
        }
        .refreshable {
            Task {
                await NetworkManager.fetchData(into: context)
                updateSectionStates()
            }
        }
        .onAppear {
            // Set default state for each section to false (closed)
            for producer in producers {
                let producerName = producer.name
                sectionStates[producerName] = false
            }
        }
        .onAppear {
            // Set default state for each section to false (closed)
            for bar in groupedProducts.keys {
                sectionStates[bar] = false
            }
        }
    }

    
    private var groupedProducts: [String: [String: [Product]]] {
        var grouped: [String: [String: [Product]]] = [:]
        
        for producer in producers {
            let producerName = producer.name
            for product in producer.products {
                let bar = product.bar
                if grouped[bar] == nil {
                    grouped[bar] = [:]
                }
                if grouped[bar]?[producerName] == nil {
                    grouped[bar]?[producerName] = []
                }
                grouped[bar]?[producerName]?.append(product)
            }
        }
        
        return grouped
    }
    
    private func toggleSection(for producerName: String) {
        sectionStates[producerName]?.toggle()
    }
    
    private func updateSectionStates() {
        // Initialize section states if not already set
        for producer in producers {
            let producerName = producer.name
            if sectionStates[producerName] == nil {
                sectionStates[producerName] = false // Or true if you want sections to start expanded
            }
        }
    }
}


struct SectionHeaderView: View {
    let title: String
    let isExpanded: Bool
    
    var body: some View {
        HStack {
            Text(title).font(.headline)
            Spacer()
            Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
        }
        .contentShape(Rectangle()) // Make the entire header tappable
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().modelContainer(for: BeerFestival.self)
    }
}
