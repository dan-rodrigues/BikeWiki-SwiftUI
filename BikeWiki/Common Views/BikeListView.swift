// BikeListView.swift
//
// Copyright (C) 2020 Dan Rodrigues <danrr.gh.oss@gmail.com>
//
// SPDX-License-Identifier: MIT

import SwiftUI
import Combine

struct BikeListView: View {

    enum ViewModel: Equatable {
        
        struct Loaded: Equatable {
            
            let header: LocalizedStringKey?
            let bikes: [Bike]
        }
        
        case loading(description: LocalizedStringKey)
        case loaded(Loaded)
        case info(LocalizedStringKey)
    }
    
    private let viewModel: ViewModel
    private let showHeader: Bool
    @ObservedObject private var favourites: FavouritesStore

    init(viewModel: ViewModel, showHeader: Bool = true, favourites: FavouritesStore) {
        self.viewModel = viewModel
        self.showHeader = showHeader
        self.favourites = favourites
    }

    var body: some View {
        Group {
            switch viewModel {
            case let .info(description):
                Text(description)
            case let .loading(description):
                ProgressView(description)
            case let .loaded(result):
                if showHeader, let header = result.header {
                    Text(header)
                        .fontWeight(.bold)
                        .padding(.init(top: 5, leading: 0, bottom: 5, trailing: 0))
                }
                Spacer(minLength: 0)
                Divider()
                Spacer(minLength: 0)
                GroupedBikeListView(bikes: result.bikes, favourites: favourites)
            }
        }
    }
}

extension BikeListView.ViewModel.Loaded {
    
    init(bikes: [Bike]) {
        self.header = nil
        self.bikes = bikes
    }
}
