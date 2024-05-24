//
//  ContentViewExtension.swift
//  CBF
//
//  Created by Adam Reynolds on 21/05/2024.
//

import SwiftUI

extension ContentView {
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

    func updateSectionStatesForSearch() {
        if searchQuery.isEmpty {
            // Close all sections if search query is empty
            for bar in groupedProducts.keys {
                sectionStates[bar] = false
            }
        } else {
            // Open all sections when search is started
            for bar in groupedProducts.keys {
                sectionStates[bar] = true
            }
        }
    }

    func toggleSection(for bar: String) {
        sectionStates[bar]?.toggle()
    }

    func updateSectionStates() {
        // Initialize section states if not already set
        for bar in groupedProducts.keys {
            if sectionStates[bar] == nil {
                sectionStates[bar] = false // Or true if you want sections to start expanded
            }
        }
    }

    func initializeSectionStates() {
        for producer in producers {
            let producerName = producer.name
            sectionStates[producerName] = false
        }
        // Also set default state for bars
        for bar in groupedProducts.keys {
            sectionStates[bar] = false
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
}
