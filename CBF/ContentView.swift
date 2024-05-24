//
//  ContentView.swift
//  CBF
//
//  Created by Adam Reynolds on 20/05/2024.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var context

    @Query(sort: \Producer.name, order: .forward) var producers: [Producer]

    @State var sectionStates: [String: Bool] = [:]
    @State var searchQuery: String = "" {
        didSet {
            updateSectionStatesForSearch()
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                // Search bar
                TextField("Search", text: $searchQuery)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                List {
                    ForEach(filteredGroupedProducts.keys.sorted(), id: \.self) { bar in
                        Section(header: SectionHeaderView(title: bar, isExpanded: sectionStates[bar] ?? false)
                            .onTapGesture {
                                toggleSection(for: bar)
                            }) {
                            if sectionStates[bar] ?? false {
                                if let producersForBar = filteredGroupedProducts[bar] {
                                    ForEach(producersForBar.keys.sorted(), id: \.self) { producerName in
                                        Section(header: Text(producerName)) {
                                            if let products = filteredGroupedProducts[bar]?[producerName] {
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
            initializeSectionStates()
        }
    }

    // Ensure groupedProducts is accessible in the main view file
    var groupedProducts: [String: [String: [Product]]] {
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

    var filteredGroupedProducts: [String: [String: [Product]]] {
        if searchQuery.isEmpty {
            return groupedProducts
        } else {
            var filtered = [String: [String: [Product]]]()
            for (bar, producersForBar) in groupedProducts {
                var filteredProducers = [String: [Product]]()
                for (producerName, products) in producersForBar {
                    let filteredProducts = products.filter { product in
                        product.name.localizedCaseInsensitiveContains(searchQuery) ||
                        producerName.localizedCaseInsensitiveContains(searchQuery)
                    }
                    if !filteredProducts.isEmpty {
                        filteredProducers[producerName] = filteredProducts
                    }
                }
                if !filteredProducers.isEmpty {
                    filtered[bar] = filteredProducers
                }
            }
            return filtered
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().modelContainer(for: BeerFestival.self)
    }
}
