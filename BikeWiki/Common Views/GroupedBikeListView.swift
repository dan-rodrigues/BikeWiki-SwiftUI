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
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(GroupedBikes(bikes: bikes).groups) { group in
                    Section(header: SectionHeader(group.manufacturer.name)) {
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
                            .accentColor(Color(.label))
                            .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
                        }
                    }
                }
            }
        }
    }
}

private struct SectionHeader: View {

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
