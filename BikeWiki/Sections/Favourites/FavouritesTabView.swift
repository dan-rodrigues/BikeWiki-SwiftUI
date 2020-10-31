// FavouritesTabView.swift
//
// Copyright (C) 2020 Dan Rodrigues <danrr.gh.oss@gmail.com>
//
// SPDX-License-Identifier: MIT

import SwiftUI

struct FavouritesTabView: View {
    
    private let viewModel: BikeListView.ViewModel
    @ObservedObject private var favourites: FavouritesStore
    
    init(viewModel: BikeListView.ViewModel, favourites: FavouritesStore) {
        self.viewModel = viewModel
        self.favourites = favourites
    }
    
    var body: some View {
        NavigationView {
            VStack {
                BikeListView(viewModel: viewModel, favourites: favourites)
            }
            .navigationBarTitle("Favourites")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
