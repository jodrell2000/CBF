//
//  ContentView.swift
//  CBF
//  Created by Adam Reynolds on 20/05/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var producers: [Producer] = []
    @State private var selectedProducts: [String: Bool] = UserDefaults.standard.dictionary(forKey: "selectedProducts") as? [String: Bool] ?? [:]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(producers) { producer in
                    Section(header: Text(producer.name).font(.headline)) {
                        ForEach(producer.products) { product in
                            NavigationLink(destination: BeerDetailView(
                                isSelected: Binding(
                                    get: { selectedProducts[product.id, default: false] },
                                    set: {
                                        selectedProducts[product.id] = $0
                                        saveSelectedProducts()
                                    }
                                ),
                                producer: producer,
                                product: product
                            )) {
                                BeerRow(isSelected: Binding(
                                    get: { selectedProducts[product.id, default: false] },
                                    set: {
                                        selectedProducts[product.id] = $0
                                        saveSelectedProducts()
                                    }
                                ), product: product)
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
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
            .onAppear {
                fetchData()
                loadSelectedProducts()
            }
        }
    }
    
    func fetchData() {
        guard let url = URL(string: "https://data.cambridgebeerfestival.com/cbf2024/beer.json") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let festival = try JSONDecoder().decode(BeerFestival.self, from: data)
                    DispatchQueue.main.async {
                        self.producers = festival.producers
                        print("Data fetched and decoded successfully")
                    }
                } catch {
                    print("Error decoding data: \(error)")
                }
            } else if let error = error {
                print("Data task error: \(error)")
            }
        }.resume()
    }
    
    func saveSelectedProducts() {
        UserDefaults.standard.set(selectedProducts, forKey: "selectedProducts")
    }
    
    func loadSelectedProducts() {
        if let savedSelectedProducts = UserDefaults.standard.dictionary(forKey: "selectedProducts") as? [String: Bool] {
            selectedProducts = savedSelectedProducts
        }
    }
}

struct BeerRow: View {
    @Binding var isSelected: Bool
    var product: Product
    
    var body: some View {
        HStack {
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
    }
}

extension Dictionary where Key == String, Value == Int {
    var description: String {
        self.keys.joined(separator: ", ")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
