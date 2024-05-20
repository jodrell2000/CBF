//
//  BeerModel.swift
//  CBF
//
//  Created by Adam Reynolds on 20/05/2024.
//

import Foundation

struct BeerFestival: Decodable {
    let producers: [Producer]
}

struct Producer: Decodable, Identifiable {
    let id: String
    let name: String
    let year_founded: String?
    let notes: String?
    let location: String?
    let products: [Product]
}

struct Product: Decodable, Identifiable {
    let id: String
    let name: String
    let notes: String?
    let allergens: Allergens
    let bar: String
    let style: String?
    let abv: String
    let category: String
    let status_text: String
    let dispense: String?
}

enum AllergenValue: Decodable, Equatable {
    case string(String)
    case int(Int)
    case empty

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intValue = try? container.decode(Int.self) {
            self = .int(intValue)
        } else if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else if container.decodeNil() {
            self = .empty
        } else {
            self = .empty // Handle other cases as empty
        }
    }

    var description: String {
        switch self {
        case .string(let value):
            return value
        case .int(let value):
            return String(value)
        case .empty:
            return ""
        }
    }

    static func == (lhs: AllergenValue, rhs: AllergenValue) -> Bool {
        switch (lhs, rhs) {
        case (.string(let lValue), .string(let rValue)):
            return lValue == rValue
        case (.int(let lValue), .int(let rValue)):
            return lValue == rValue
        case (.empty, .empty):
            return true
        default:
            return false
        }
    }
}


struct Allergens: Decodable {
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

        if let gluten = gluten, gluten != .empty, gluten.description != "0" {
            names.append("Gluten")
        }
        if let molluscs = molluscs, molluscs != .empty, molluscs.description != "0" {
            names.append("Molluscs")
        }
        if let egg = egg, egg != .empty, egg.description != "0" {
            names.append("Egg")
        }
        if let fish = fish, fish != .empty, fish.description != "0" {
            names.append("Fish")
        }
        if let lupins = lupins, lupins != .empty, lupins.description != "0" {
            names.append("Lupins")
        }
        if let soybeans = soybeans, soybeans != .empty, soybeans.description != "0" {
            names.append("Soybeans")
        }
        if let celery = celery, celery != .empty, celery.description != "0" {
            names.append("Celery")
        }
        if let sesame = sesame, sesame != .empty, sesame.description != "0" {
            names.append("Sesame")
        }
        if let crustaceans = crustaceans, crustaceans != .empty, crustaceans.description != "0" {
            names.append("Crustaceans")
        }
        if let peanuts = peanuts, peanuts != .empty, peanuts.description != "0" {
            names.append("Peanuts")
        }
        if let mustard = mustard, mustard != .empty, mustard.description != "0" {
            names.append("Mustard")
        }

        return names
    }
}
