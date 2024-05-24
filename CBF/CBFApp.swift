//
//  CBFApp.swift
//  CBF
//
//  Created by Adam Reynolds on 20/05/2024.
//

import SwiftUI

@main
struct CBFApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: BeerFestival.self)
        }
    }
}
