// SearchTabView.swift
//
// Copyright (C) 2020 Dan Rodrigues <danrr.gh.oss@gmail.com>
//
// SPDX-License-Identifier: MIT

import SwiftUI

struct SearchTabView: View {
    
    private let viewModel: BikeListView.ViewModel
    @Binding private var searchInput: String
    @ObservedObject private var favourites: FavouritesStore

    init(
        searchInput: Binding<String>,
        viewModel: BikeListView.ViewModel,
        favourites: FavouritesStore)
    {
        self.viewModel = viewModel
        self._searchInput = searchInput
        self.favourites = favourites
    }
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBarView(text: $searchInput)
                Spacer(minLength: 0)
                BikeListView(viewModel: viewModel, favourites: favourites)
                Spacer(minLength: 0)
            }
            .navigationBarTitle("Search")
        }
        // This forces the compact layout even on iPads
        // By default there is a split view which is mostly fine, but shows an empty screen initially
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
