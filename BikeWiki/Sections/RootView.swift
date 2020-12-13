// RootView.swift
//
// Copyright (C) 2020 Dan Rodrigues <danrr.gh.oss@gmail.com>
//
// SPDX-License-Identifier: MIT

import SwiftUI
import Combine

struct RootView: View {
    
    struct ViewModel {
        
        enum Presentation {
            
            case empty
            case search(state: SearchState)
        }
        
        let presentation: Presentation
    }
        
    @StateObject private var searchViewModelFactory = SearchTabViewModelFactory(
        searchPerformer: ServiceProvider.shared.implementor(of: SearchPerforming.self)
    )
    @StateObject private var favouritesViewModelFactory = FavouritesTabViewModelFactory()
        
    @ObservedObject private var favourites: FavouritesStore
    
    init(favourites: FavouritesStore) {
        self.favourites = favourites
    }
    
    var body: some View {
        TabView(selection: $favouritesViewModelFactory.selectedTab) {
            SearchTabView(
                searchInput: $searchViewModelFactory.autocompleteInput,
                viewModel: searchViewModelFactory.viewModel,
                favourites: favourites
            )
            .tabItem {
                Label("Search", systemImage: "magnifyingglass.circle.fill")
            }
            .tag(TabSelection.search)
            
            FavouritesTabView(
                viewModel: favouritesViewModelFactory.viewModel,
                favourites: favourites
            )
            .tabItem {
                Label("Favourites", systemImage: "star.fill")
            }
            .tag(TabSelection.favourites)
        }
        .onAppear {
            favourites.$favourites
                .assign(to: &favouritesViewModelFactory.$favouriteBikeIds)
        }
    }
}
