//
//  NetworkManager.swift
//  CBF
//
//  Created by Adam Reynolds on 23/05/2024.
//

import Foundation
import SwiftData

struct NetworkManager {
    private static let baseURL = "https://data.cambridgebeerfestival.com/cbf2024/"
    private static let endpoints = [
        "apple-juice.json",
        "beer.json",
        "cider.json",
        "international-beer.json",
        "mead.json",
        "perry.json",
        "wine.json"
    ]
    
    @MainActor
    static func fetchData(into modelContext: ModelContext) async {
        for endpoint in endpoints {
            guard let url = URL(string: baseURL + endpoint) else {
                print("Invalid URL: \(endpoint)")
                continue
            }
            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                var apiFestival = try JSONDecoder().decode(APIBeerFestival.self, from: data)
                
                if endpoint != "beer.json" {
                    apiFestival = updateProductsForNonBeerFiles(apiFestival: apiFestival, endpoint: endpoint)
                }
                
                let festival = BeerFestival.updateOrCreate(from: apiFestival, using: modelContext)
                modelContext.insert(festival)
            } catch {
                print("Failed to load data from \(url): \(error)")
            }
        }
    }
    
    private static func updateProductsForNonBeerFiles(apiFestival: APIBeerFestival, endpoint: String) -> APIBeerFestival {
        var updatedProducers = apiFestival.producers
        for (producerIndex, producer) in updatedProducers.enumerated() {
            for (productIndex, product) in producer.products.enumerated() {
                if product.bar == nil {
                    updatedProducers[producerIndex].products[productIndex].bar = getDefaultBarValue(for: endpoint)
                }
            }
        }
        return APIBeerFestival(producers: updatedProducers)
    }
    
    private static func getDefaultBarValue(for endpoint: String) -> String {
        switch endpoint {
        case "apple-juice.json":
            return "Cider Bar"
        case "cider.json":
            return "Cider Bar"
        case "international-beer.json":
            return "International Bar"
        case "mead.json":
            return "Mead & Wine Bar"
        case "perry.json":
            return "Cider Bar"
        case "wine.json":
            return "Mead & Wine Bar"
        default:
            return "Unknown Bar"
        }
    }
}

fileprivate struct APIBeerFestival: Decodable {
    let producers: [APIProducer]
}

fileprivate struct APIProducer: Decodable {
    let id: String
    let name: String
    let yearFounded: String?
    let notes: String?
    let location: String?
    var products: [APIProduct]

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case yearFounded = "year_founded"
        case notes
        case location
        case products
    }
}

fileprivate struct APIProduct: Decodable {
    let id: String
    let name: String
    let notes: String?
    let allergens: Allergens?
    var bar: String?
    let style: String?
    let abv: String?
    let category: String
    let statusText: String
    let dispense: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case notes
        case allergens
        case bar
        case style
        case abv
        case category
        case statusText = "status_text"
        case dispense
    }
}

fileprivate extension BeerFestival {
    static func updateOrCreate(from apiBeerFestival: APIBeerFestival, using context: ModelContext) -> BeerFestival {
        let festivalProducers = apiBeerFestival.producers.map({ Producer.updateOrCreate(from: $0, using: context) })

        var existingBeerFestivalFetch = FetchDescriptor<BeerFestival>()
        existingBeerFestivalFetch.includePendingChanges = true

        var beerFestival: BeerFestival
        
        if let existingBeerFestival = try? context.fetch(existingBeerFestivalFetch).first {
            existingBeerFestival.producers = festivalProducers
            
            beerFestival = existingBeerFestival
        } else {
            beerFestival = BeerFestival(producers: festivalProducers)
        }
        
        return beerFestival
    }
}

fileprivate extension Producer {
    static func updateOrCreate(from apiProducer: APIProducer, using context: ModelContext) -> Producer {
        let producerProducts = apiProducer.products.map({ Product.updateOrCreate(from: $0, using: context) })
        
        let apiID = apiProducer.id
        var existingProducerFetch = FetchDescriptor<Producer>(predicate: #Predicate { $0.id == apiID })
        existingProducerFetch.includePendingChanges = true

        var producer: Producer
        
        if let existingProducer = try? context.fetch(existingProducerFetch).first {
            existingProducer.name = apiProducer.name
            existingProducer.yearFounded = apiProducer.yearFounded
            existingProducer.notes = apiProducer.notes
            existingProducer.location = apiProducer.location
            existingProducer.products = producerProducts
            
            producer = existingProducer
        } else {
            producer = Producer(id: apiProducer.id, name: apiProducer.name, yearFounded: apiProducer.yearFounded, notes: apiProducer.notes, location: apiProducer.location, products: producerProducts)
        }
        
        return producer
    }
}

fileprivate extension Product {
    static func updateOrCreate(from apiProduct: APIProduct, using context: ModelContext) -> Product {
        let apiID = apiProduct.id
        var existingProductFetch = FetchDescriptor<Product>(predicate: #Predicate { $0.id == apiID })
        existingProductFetch.includePendingChanges = true

        if let existingProduct = try? context.fetch(existingProductFetch).first {
            existingProduct.name = apiProduct.name
            existingProduct.allergens = apiProduct.allergens
            existingProduct.bar = apiProduct.bar ?? ""
            existingProduct.abv = apiProduct.abv ?? ""
            existingProduct.category = apiProduct.category
            existingProduct.statusText = apiProduct.statusText
            
            return existingProduct
        } else {
            return Product.init(id: apiProduct.id, name: apiProduct.name, allergens: apiProduct.allergens, bar: apiProduct.bar ?? "", abv: apiProduct.abv ?? "", category: apiProduct.category, statusText: apiProduct.statusText, isSelected: false, isFavourite: false)
        }
    }
}
