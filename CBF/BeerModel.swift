//
//  BeerModel.swift
//  CBF
//
//  Created by Adam Reynolds on 20/05/2024.
//

import Foundation
import SwiftData

@Model
class BeerFestival {
    @Relationship(deleteRule: .cascade, inverse: \Producer.beerFestival) var producers = [Producer]()
    
    init(producers: [Producer] = [Producer]()) {
        self.producers = producers
    }
}

@Model
class Producer: Identifiable {
    @Attribute(.unique) var id: String
    var name: String
    var yearFounded: String?
    var notes: String?
    var location: String?
    var beerFestival: BeerFestival?
    
    @Relationship(deleteRule: .cascade, inverse: \Product.producer) var products = [Product]()
    
    init(id: String, name: String, yearFounded: String? = nil, notes: String? = nil, location: String? = nil, beerFestival: BeerFestival? = nil, products: [Product] = [Product]()) {
        self.id = id
        self.name = name
        self.yearFounded = yearFounded
        self.notes = notes
        self.location = location
        self.beerFestival = beerFestival
        self.products = products
    }
}

@Model
class Product: Identifiable {
    @Attribute(.unique) var id: String
    var name: String
    var notes: String?
    var allergens: Allergens?
    var bar: String
    var style: String?
    var abv: String
    var category: String
    var statusText: String
    var dispense: String?
    
    var isSelected: Bool
    var isFavourite: Bool
    
    var producer: Producer?
    
    init(id: String, name: String, notes: String? = nil, allergens: Allergens? = nil, bar: String, style: String? = nil, abv: String, category: String, statusText: String, dispense: String? = nil, isSelected: Bool, isFavourite: Bool, producer: Producer? = nil) {
        self.id = id
        self.name = name
        self.notes = notes
        self.allergens = allergens
        self.bar = bar
        self.style = style
        self.abv = abv
        self.category = category
        self.statusText = statusText
        self.dispense = dispense
        self.isSelected = isSelected
        self.isFavourite = isFavourite
        self.producer = producer
    }
}

enum AllergenValue: Codable, Equatable {
    case string(String)
    case int(Int)
    case none

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intValue = try? container.decode(Int.self) {
            self = .int(intValue)
        } else if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else if container.decodeNil() {
            self = .none
        } else {
            throw DecodingError.typeMismatch(AllergenValue.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unsupported type"))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .int(let intValue):
            try container.encode(intValue)
        case .string(let stringValue):
            try container.encode(stringValue)
        case .none:
            try container.encodeNil()
        }
    }
    
    var description: String {
        switch self {
        case .string(let value):
            return value
        case .int(let value):
            return String(value)
        case .none:
            return ""
        }
    }

    static func == (lhs: AllergenValue, rhs: AllergenValue) -> Bool {
        switch (lhs, rhs) {
        case (.string(let lValue), .string(let rValue)):
            return lValue == rValue
        case (.int(let lValue), .int(let rValue)):
            return lValue == rValue
        case (.none, .none):
            return true
        default:
            return false
        }
    }
}

struct Allergens: Codable {
    let gluten: AllergenValue?
    let molluscs: AllergenValue?
    let egg: AllergenValue?
    let fish: AllergenValue?
    let lupins: AllergenValue?
    let soybeans: AllergenValue?
    let celery: AllergenValue?
    let sesame: AllergenValue?
    let crustaceans: AllergenValue?
    let peanuts: AllergenValue?
    let mustard: AllergenValue?

    var allergenNames: [String] {
        var names: [String] = []

        if let gluten = gluten, gluten != .none, gluten.description != "0" {
            names.append("Gluten")
        }
        if let molluscs = molluscs, molluscs != .none, molluscs.description != "0" {
            names.append("Molluscs")
        }
        if let egg = egg, egg != .none, egg.description != "0" {
            names.append("Egg")
        }
        if let fish = fish, fish != .none, fish.description != "0" {
            names.append("Fish")
        }
        if let lupins = lupins, lupins != .none, lupins.description != "0" {
            names.append("Lupins")
        }
        if let soybeans = soybeans, soybeans != .none, soybeans.description != "0" {
            names.append("Soybeans")
        }
        if let celery = celery, celery != .none, celery.description != "0" {
            names.append("Celery")
        }
        if let sesame = sesame, sesame != .none, sesame.description != "0" {
            names.append("Sesame")
        }
        if let crustaceans = crustaceans, crustaceans != .none, crustaceans.description != "0" {
            names.append("Crustaceans")
        }
        if let peanuts = peanuts, peanuts != .none, peanuts.description != "0" {
            names.append("Peanuts")
        }
        if let mustard = mustard, mustard != .none, mustard.description != "0" {
            names.append("Mustard")
        }

        return names
    }
}
