//
//  DataManager.swift
//  CBF
//
//  Created by Adam Reynolds on 21/05/2024.
//

import SwiftUI
import Combine

class DataManager: ObservableObject {
    @Published var producers: [Producer] = []
    @Published var selectedProducts: [String: Bool] = UserDefaults.standard.dictionary(forKey: "selectedProducts") as? [String: Bool] ?? [:]
    
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
