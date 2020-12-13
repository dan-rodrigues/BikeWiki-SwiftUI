// GroupedBikeListView.swift
//
// Copyright (C) 2020 Dan Rodrigues <danrr.gh.oss@gmail.com>
//
// SPDX-License-Identifier: MIT

import SwiftUI

struct GroupedBikeListView: View {
    
    private let bikes: [Bike]
    @ObservedObject private var favourites: FavouritesStore
    
    init(bikes: [Bike], favourites: FavouritesStore) {
        self.bikes = bikes
        self.favourites = favourites
    }
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(GroupedBikes(bikes: bikes).groups) { group in
                        Section(header: SectionHeaderView(group.manufacturer.name)) {
                            ForEach(group.bikes, id: \.id) { bike in
                                NavigationLink(
                                    destination: BikeDetailView(
                                        viewModel: .init(
                                            bike: bike,
                                            favouritesBinding: favourites.binding(forBikeId: bike.id))
                                    ),
                                    label: { BikeSummaryRowView(
                                        viewModel: .init(
                                            bike: bike,
                                            favouritesBinding: favourites.binding(forBikeId: bike.id)
                                        )
                                    )
                                    }
                                )
                                .frame(width: geo.size.width - 16, height: geo.size.width / 4)
                                .accentColor(Color(.label))
                            }
                        }
                    }
                }
                .padding(8)
            }
        }
    }
}

private struct SectionHeaderView: View {

    private let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(text)
            .fontWeight(.bold)
    }
}

private struct GroupedBikes {
    
    struct BikeGroup: Identifiable {
        
        var id: Manufacturer {
            return manufacturer
        }
        
        let manufacturer: Manufacturer
        let bikes: [Bike]
    }
    
    let groups: [BikeGroup]
    
    init(bikes: [Bike]) {
        var dictionary: [Manufacturer: [Bike]] = [:]
        
        bikes.forEach { bike in
            var bikes = dictionary[bike.manufacturer] ?? []
            bikes.append(bike)
            dictionary[bike.manufacturer] = bikes
        }
        
        var groups = [BikeGroup]()
        dictionary.sorted(by: { $0.key.name < $1.key.name }) .forEach { key, value in
            groups.append(.init(manufacturer: key, bikes: value))
        }
        self.groups = groups
    }
}
