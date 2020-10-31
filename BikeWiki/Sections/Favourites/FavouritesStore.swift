// FavouritesStore.swift
//
// Copyright (C) 2020 Dan Rodrigues <danrr.gh.oss@gmail.com>
//
// SPDX-License-Identifier: MIT

import SwiftUI
import Combine

final class FavouritesStore: ObservableObject {

    @Published private(set) var favourites: Set<Bike.ID> = []

    func binding(forBikeId bikeId: Bike.ID) -> Binding<Bool> {
        return Binding {
            return self.favourites.contains(bikeId)
        } set: { isFavourite in
            if isFavourite {
                self.favourites.insert(bikeId)
            } else {
                self.favourites.remove(bikeId)
            }
        }
    }
}
